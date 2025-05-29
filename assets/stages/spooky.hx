var bg:FlxSprite;

Paths.sound('stages/spooky/thunder0');
Paths.sound('stages/spooky/thunder1');

function onCreate()
{
    bg = new FlxSprite(-200, -100);

    if (ClientPrefs.data.lowQuality)
    {
        bg.loadGraphic(Paths.image('stages/spooky/lowBG'));
    } else {
        bg.frames = Paths.getSparrowAtlas('stages/spooky/bg');
        bg.animation.addByPrefix('idle', 'halloweem bg0');
        bg.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
        bg.animation.play('idle');
    }
    
    add(bg);
    bg.antialiasing = ClientPrefs.data.antialiasing;
}

var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function onBeatHit(curBeat:Int)
{
    if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
        lightning(curBeat);
}

function lightning(curBeat:Int)
{
    FlxG.sound.play(Paths.sound('stages/spooky/thunder' + FlxG.random.int(0, 1)));

    if (!ClientPrefs.data.lowQuality)
        bg.animation.play('lightning');

    lightningStrikeBeat = curBeat;

    lightningOffset = FlxG.random.int(8, 24);

    for (group in this.characters.getGroups())
        for (character in group)
            if (character.animation.exists('scared'))
            {
                character.idleTimer = -60 / Conductor.bpm;

                character.animation.play('scared', true);
            }
}