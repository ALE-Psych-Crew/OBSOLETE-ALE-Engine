var back:FlxSprite;
var front:FlxSprite;
var leftLight:FlxSprite;
var rightLight:FlxSprite;
var curtains:FlxSprite;

function onCreate()
{
    back = createSprite('back', -600, -200);

    front = createSprite('front', -650, 620, 1.1);
}

function postCreate()
{
    if (ClientPrefs.data.lowQuality)
        return;

    leftLight = createSprite('light', -125, -100, 1.1);

    rightLight = createSprite('light', 1225, -100, 1.1);
    rightLight.flipX = true;

    curtains = createSprite('curtains', -500, -300, 0.9, 1.3);
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float):FlxSprite
{
    var sprite:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image('stages/stage/' + image));
    add(sprite);
    sprite.scale.x = sprite.scale.y = scale ?? 1;
    sprite.updateHitbox();
    sprite.scrollFactor.x = sprite.scrollFactor.y = scroll ?? 1;
    sprite.antialiasing = ClientPrefs.data.antialiasing;

    return sprite;
}