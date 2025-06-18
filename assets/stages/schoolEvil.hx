var bg:FlxSprite;

function onCreate()
{
    bg = new FlxSprite(400, 200);

    if (ClientPrefs.data.lowQuality)
    {
        bg.loadGraphic(Paths.image('stages/schoolEvil/lowSchool'));
    } else {
        bg.frames = Paths.getSparrowAtlas('stages/schoolEvil/school');
        bg.animation.addByPrefix('idle', 'background 2');
        bg.animation.play('idle');
    }

    bg.scale.set(6, 6);
    add(bg);
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