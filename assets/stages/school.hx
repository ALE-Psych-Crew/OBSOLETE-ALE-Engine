var sky:FlxSprite;

var school:FlxSprite;
var street:FlxSprite;

var trunk:FlxSprite;
var trees:FlxSprite;
var leaves:FlxSprite;

var freaks:FlxSprite;

function onCreate()
{
    sky = createSprite('sky', 0, 0, 1, 0.1);

    school = createSprite('school', -200, 0, 1, 0.6);
    school.scrollFactor.y = 0.9;

    street = createSprite('street', -200, 0, 1, 0.95);

    trunk = createSprite('trunk', -30, 130, 0.8, 0.9);

    trees = new FlxSprite(-580, -800);
    trees.scrollFactor.set(0.85, 0.85);
    trees.frames = Paths.getPackerAtlas('stages/school/trees');
    trees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
    trees.animation.play('treeLoop');
    add(trees);
    trees.setGraphicSize(sky.width * 1.4);
    trees.updateHitbox();

    if (!ClientPrefs.data.lowQuality)
    {
        leaves = createSprite('petals', -200, 40, 1, 0.85, true, [['petals', 'PETALS ALL']], true);

        freaks = createSprite('freaks', -100, 190, 1, 0.9, true, [['dance', 'BG girls group']]);
        freaks.animation.addByIndices('danceLeft', 'BG girls group', [for (i in 0...14) i], '', 24, false);
		freaks.animation.addByIndices('danceRight', 'BG girls group', [for (i in 15...30) i], '', 24, false);
        freaks.animation.play('danceLeft');
    }
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float, ?addInState:Bool, ?animations:Array<Array<String>>, ?loop:Bool):FlxSprite
{
    var sprite:FlxSprite = new FlxSprite(x, y);
    
    if (animations == null)
    {
        sprite.loadGraphic(Paths.image('stages/school/' + image));
    } else {
        if (loop == null)
            loop = false;

        sprite.frames = Paths.getAtlas('stages/school/' + image);

        for (anim in animations)
            sprite.animation.addByPrefix(anim[0], anim[1], 24, loop);

        sprite.animation.play(animations[0][0]);
    }

    if (addInState == null)
        addInState = true;

    if (addInState)
        add(sprite);

    sprite.scale.x = sprite.scale.y = 6 * (scale ?? 1);
    sprite.scrollFactor.x = sprite.scrollFactor.y = scroll ?? 1;
    sprite.updateHitbox();

    return sprite;
}

function onBeatHit(curBeat:Int)
{
    if (!ClientPrefs.data.lowQuality)
        freaks.animation.play(curBeat % 2 == 0 ? 'danceLeft' : 'danceRight', true);
}

function onInitHUD()
{
    this.ratingsDirectory = 'pixel';
    this.ratingsScale = 7;
}

function postInitHUD()
{
    for (obj in this.comboGroup)
        obj.antialiasing = false;
}

function onInitCountdown()
{
    this.countdownDirectory = 'pixel';
    this.countdownScale = 10;
}

function postInitCountdown()
{
    this.countdownSprite.antialiasing = false;
}

function postCreate()
{
    for (group in this.strumLines.getGroups())
    {
        for (strl in group)
        {
            for (splash in strl.splashes)
                splash.alpha = 0;

            for (strum in strl.strums)
            {
                strum.texture = 'pixelNote';
                strum.scale.set(6, 6);
                strum.updateHitbox();
                strum.antialiasing = false;
            }
        }
    }
    
    this.camGame.pixelPerfectRender = true;
    this.camHUD.pixelPerfectRender = true;
}

function onNoteSpawn(note:Note)
{
    note.texture = 'pixelNote';
    note.scale.set(6, 6);
    note.updateHitbox();
    note.antialiasing = false;
}

function onDestroy()
{
    this.camGame.pixelPerfectRender = false;
    this.camHUD.pixelPerfectRender = false;
}