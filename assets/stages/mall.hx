var bg:FlxSprite;

var upperBoppers:FlxSprite;
var escalator:FlxSprite;

var tree:FlxSprite;
var snow:FlxSprite;
var bottomBop:FlxSprite;

var santa:FlxSprite;

function onCreate()
{
    bg = createSprite('wall', -1000, -500, 1, 0.2);

    if (!ClientPrefs.data.lowQuality)
    {
        upperBoppers = createSprite('upperBop', -240, -90, 0.85, 0.3, true, [['idle', 'Upper Crowd Bob']]);

        escalator = createSprite('escalator', -1100, -600, 0.9, 0.3);
    }

    tree = createSprite('tree', 370, -250, 1, 0.4);
    
    bottomBop = createSprite('bottomBop', -300, 140, 1, 1, true, [['idle', 'Bottom Level Boppers Idle'], ['hey', 'Bottom Level Boppers HEY']]);

    snow = createSprite('snow', -600, 700);

    santa = createSprite('santa', -860, 140, 1, 1, true, [['idle', 'santa idle in fear']]);
}

function onBeatHit()
{
    for (sprite in [upperBoppers, bottomBop, santa])
        if (sprite != null)
            sprite.animation.play('idle', true);
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float, ?addInState:Bool, ?animations:Array<Array<String>>, ?loop:Bool):FlxSprite
{
    var sprite:FlxSprite = new FlxSprite(x, y);
    
    if (animations == null)
    {
        sprite.loadGraphic(Paths.image('stages/mall/' + image));
    } else {
        if (loop == null)
            loop = false;

        sprite.frames = Paths.getSparrowAtlas('stages/mall/' + image);

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