var wall:FlxSprite;
var tree:FlxSprite;
var snow:FlxSprite;

function onCreate()
{
    wall = createSprite('wall', -400, -500, 0.8, 0.2);
    tree = createSprite('tree', 300, -300, 1, 0.3);
    snow = createSprite('snow', -200, 700);
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float):FlxSprite
{
    var sprite:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image('stages/mallEvil/' + image));
    add(sprite);
    sprite.scale.x = sprite.scale.y = scale ?? 1;
    sprite.updateHitbox();
    sprite.scrollFactor.x = sprite.scrollFactor.y = scroll ?? 1;
    sprite.antialiasing = ClientPrefs.data.antialiasing;

    return sprite;
}