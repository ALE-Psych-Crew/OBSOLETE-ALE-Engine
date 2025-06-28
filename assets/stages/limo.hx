import flixel.group.FlxTypedGroup;

var dancers:FlxTypedGroup;

var sunset:FlxSprite;
var limo:FlxSprite;
var mainLimo:FlxSprite;
var car:FlxSprite;

function onCreate()
{
    sunset = createSprite('sunset', -120, -50, 1, 0.1);
    
    dancers = new FlxTypedGroup();
    add(dancers);

    if (!ClientPrefs.data.lowQuality)
    {
        limo = createSprite('limo', -159, 480, 1, 0.4, true, [['pink', 'background limo pink']], true);

        for (i in 0...5)
        {
            var dancer:FlxSprite = createSprite('dancer', 370 * i + 320 + limo.x, limo.y - 400, 1, 0.4, false, [['danceLeft', 'danceLeft'], ['danceRight', 'danceRight']]);
            dancers.add(dancer);
        }
    }

    car = createSprite('car', -300, 160);
    
    resetCar();

    mainLimo = createSprite('mainLimo', -120, 550, 1, 1, true, [['limo', 'Limo stage']], true);
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float, ?addInState:Bool, ?animations:Array, ?loop:Bool):FlxSprite
{
    var sprite:FlxSprite = new FlxSprite(x, y);
    
    if (animations == null)
    {
        sprite.loadGraphic(Paths.image('stages/limo/' + image));
    } else {
        if (loop == null)
            loop = false;

        sprite.frames = Paths.getSparrowAtlas('stages/limo/' + image);

        for (anim in animations)
            sprite.animation.addByPrefix(anim[0], anim[1], 24, loop);

        sprite.animation.play(animations[0][0]);
    }

    if (addInState == null)
        addInState = true;

    if (addInState)
        add(sprite);

    sprite.scale.x = sprite.scale.y = scale ?? 1;
    sprite.updateHitbox();
    sprite.scrollFactor.x = sprite.scrollFactor.y = scroll ?? 1;
    sprite.antialiasing = ClientPrefs.data.antialiasing;

    return sprite;
}

var carCanDrive:Bool = true;

function onBeatHit(curBeat:Int)
{
    for (dancer in dancers)
        dancer.animation.play(curBeat % 2 == 0 ? 'danceLeft' : 'danceRight', true);

    if (FlxG.random.bool(10) && carCanDrive)
        carDrive();
}

var carTimer:FlxTimer;

function carDrive()
{
    FlxG.sound.play(Paths.sound('stages/limo/car' + FlxG.random.int(0, 1)), 0.7);

    car.velocity.x = FlxG.random.int(30600, 39600);

    carCanDrive = false;

    carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
    {
        resetCar();

        carTimer = null;
    });
}

function resetCar():Void
{
    car.x = -12600;
    car.y = FlxG.random.int(140, 250);
    car.velocity.x = 0;
    carCanDrive = true;
}