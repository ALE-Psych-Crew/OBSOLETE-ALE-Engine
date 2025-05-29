import flixel.sound.FlxSound;

var sky:FlxSprite;
var city:FlxSprite;
var windows:FlxSprite;
var behindTrain:FlxSprite;
var street:FlxSprite;
var train:FlxSprite;

var trainSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound('stages/philly/train'));
FlxG.sound.list.add(trainSound);

function onCreate()
{
    if (!ClientPrefs.data.lowQuality)
        sky = createSprite('sky', -100, 0, 1, 0.1);

    city = createSprite('city', -10, 0, 0.85, 0.3);

    windows = createSprite('windows', 80, 180, 0.85, 0.3);
    windows.alpha = 0;

    if (!ClientPrefs.data.lowQuality)
        behindTrain = createSprite('behindTrain', -40, 60);

    train = createSprite('train', -3400, 340);

    street = createSprite('street', -140, 100);
    street.scale.x = 1.3;
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float):FlxSprite
{
    var sprite:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image('stages/philly/' + image));
    add(sprite);
    sprite.scale.x = sprite.scale.y = scale ?? 1;
    sprite.updateHitbox();
    sprite.scrollFactor.x = sprite.scrollFactor.y = scroll ?? 1;
    sprite.antialiasing = ClientPrefs.data.antialiasing;

    return sprite;
}

var windowColors:Array<Int> = [
    0xFF31A2FD,
    0xFF31FD8C,
    0xFFFB33F5,
    0xFFFD4531,
    0xFFFBA633
];

var curColor:Int = 0;

var calledFinish:Bool = true;
var playedGFAnim:Bool = true;

var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;
var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;

function onUpdate(elapsed:Float)
{
    if (trainMoving)
    {
        trainFrameTiming += elapsed;

        if (trainFrameTiming >= 1 / 24)
        {
            updateTrainPos();

            trainFrameTiming = 0;
        }
    }
}

var curColor:Int = 0;

function onBeatHit(curBeat:Int)
{
    if (curBeat % 4 == 0)
    {
        windows.alpha = 1;

        curColor = FlxG.random.int(0, windowColors.length - 1, [curColor]);
        
        windows.color = windowColors[curColor];

        FlxTween.cancelTweensOf(windows);
        FlxTween.tween(windows, {alpha: 0}, 240 / Conductor.bpm);
    }

    if (!trainMoving)
        trainCooldown += 1;

    if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
    {
        trainCooldown = FlxG.random.int(-4, 0);

        trainStart();
    }
}

function trainStart():Void
{
    trainMoving = true;
    
    trainSound.stop();
    trainSound.play();
}

var startedMoving:Bool = false;

function updateTrainPos():Void
{
    if (trainSound.time >= 4700)
    {
        startedMoving = true;

        getCharacter('extra', 0).animation.play('hairBlow');
        getCharacter('extra', 0).allowIdle = false;
    }

    if (startedMoving)
    {
        train.x -= 400;

        if (train.x < -2000 && !trainFinishing)
        {
            train.x = -1150;
            trainCars -= 1;

            if (trainCars <= 0)
                trainFinishing = true;
        }

        if (train.x < -4000 && trainFinishing)
            trainReset();
    }
}

function trainReset():Void
{
    getCharacter('extra', 0).animation.play('hairFall', true);

    getCharacter('extra', 0).animation.onFinish.add(function(name:String) { if (name == 'hairFall') getCharacter('extra', 0).allowIdle = true; });

    train.x = FlxG.width + 200;

    trainMoving = false;
    trainCars = 8;
    trainFinishing = false;
    startedMoving = false;
}