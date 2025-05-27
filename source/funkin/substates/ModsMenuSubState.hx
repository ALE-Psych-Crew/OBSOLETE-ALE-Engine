package funkin.substates;

import funkin.visuals.objects.Alphabet;

import core.backend.Mods;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

import flixel.util.FlxSave;

class ModsMenuSubState extends MusicBeatSubState
{
    var sprites:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();

    var selInt:Int = 0;

    var modCamera:FlxCamera;

    var camPos = {x: 0.0, y: 0.0};

    var ignoreFolders:Array<String> = [
        '.git',
        'characters',
        'custom_events',
        'custom_notetypes',
        'data',
        'songs',
        'music',
        'sounds',
        'shaders',
        'videos',
        'images',
        'stages',
        'weeks',
        'fonts',
        'scripts',
        'Disable Mods'
    ];

    var options:Array<String> = [];

    override function create()
    {
        super.create();

        if (FileSystem.exists('mods') && FileSystem.isDirectory('mods'))
            for (folder in FileSystem.readDirectory('mods'))
                if (FileSystem.isDirectory('mods/' + folder) && !ignoreFolders.contains(folder))
                    options.push(folder);

        options.push('Disable Mods');

        modCamera = new FlxCamera();
        modCamera.bgColor = FlxColor.TRANSPARENT;

        FlxG.cameras.add(modCamera, false);
        var bg:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0xFF141820, 0xFF1F232B));
        add(bg);
        bg.scrollFactor.set();
        bg.alpha = 0;
        FlxTween.tween(bg, {alpha: 0.6}, 0.25, {ease: FlxEase.cubeOut});
        bg.cameras = [modCamera];
        bg.velocity.x = bg.velocity.y = 100;

        add(sprites);

        for (option in options)
        {
            var sprite = new Alphabet(0, 0, option);
            sprites.add(sprite);
            sprite.cameras = [modCamera];

            FlxTween.tween(sprite, {x: 20 * options.indexOf(option), y: 125 * options.indexOf(option)}, 0.2, {ease: FlxEase.cubeOut});
        }

        changeShit();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        modCamera.scroll.x = CoolUtil.fpsLerp(modCamera.scroll.x, camPos.x, 0.2);
        modCamera.scroll.y = CoolUtil.fpsLerp(modCamera.scroll.y, camPos.y, 0.2);

        if (Controls.BACK)
            close();

        if (Controls.ACCEPT)
        { 
            var save:FlxSave = new FlxSave();
            save.bind('ALEEngineData', CoolUtil.getSavePath(false));
            save.data.currentMod = options[selInt] == 'Disable Mods' ? '' : options[selInt];
            save.flush();

            CoolUtil.resetEngine();
        }

        if (Controls.UI_DOWN_P || Controls.UI_UP_P || FlxG.mouse.wheel != 0)
        {
            if (Controls.UI_DOWN_P || FlxG.mouse.wheel < 0)
            {
                if (selInt >= sprites.members.length - 1)
                    selInt = 0;
                else
                    selInt++;
            }
        
            if (Controls.UI_UP_P || FlxG.mouse.wheel > 0)
            {
                if (selInt == 0)
                    selInt = sprites.members.length - 1;
                else
                    selInt--;
            }
            
            changeShit();

            FlxG.sound.play(Paths.sound('scrollMenu'));
        }
    }

    override function destroy()
    {
        FlxG.cameras.remove(modCamera);

        super.destroy();
    }

    function changeShit()
    {
        for (sprite in sprites)
        {
            if (sprites.members.indexOf(sprite) == selInt)
            {
                sprite.alpha = 1;

                camPos.x = sprite.x - 100;
                camPos.y = sprite.y - 300;
            } else {
                sprite.alpha = 0.4;
            }
        }
    }
}