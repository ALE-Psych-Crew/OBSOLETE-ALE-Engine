package funkin.substates;

import haxe.ds.StringMap;

import core.structures.ControlsOption;

import funkin.visuals.objects.ControlsAlphabet;

import flixel.addons.display.FlxGridOverlay;
import flixel.effects.FlxFlicker;

class ControlsSubState extends MusicBeatSubState
{
    var subCamera:FlxCamera;

    var bg:FlxSprite;

    var defaultOptions:Array<ControlsOption> = [
        {
            name: 'notes',
            options: [
                'left',
                'down',
                'up',
                'right' 
            ]
        },
        {
            name: 'ui',
            options: [
                'left',
                'down',
                'up',
                'right',
                'accept',
                'back',
                'reset',
                'pause'
            ]
        },
        {
            name: 'engine',
            options: [
                'switch_mod',
                'reset_game',
                'fps_counter',
                'master_menu'
            ]
        }
    ];

    var selInt:Dynamic = {
        x: 0,
        y: 0
    };

    var options:Array<Array<ControlsAlphabet>> = [];

    var sectionHeight:Float = 180;

    override function create()
    {
        super.create();
        
        subCamera = new FlxCamera();
        subCamera.bgColor = FlxColor.TRANSPARENT;

        FlxG.cameras.add(subCamera, false);

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);
        bg.cameras = [subCamera];
        bg.alpha = 0;
        bg.scrollFactor.set();

        var title:ControlsAlphabet = new ControlsAlphabet(100, 'Controls', TITLE);
        add(title);
        title.cameras = [subCamera];

        sectionHeight += title.height;

        FlxTween.tween(bg, {alpha: 0.75}, 0.5, {ease: FlxEase.cubeOut});

        spawnOptions();

        changeOption();
    }

    function spawnOptions()
    {
        for (superOption in defaultOptions)
        {
            var alpha:ControlsAlphabet = new ControlsAlphabet(sectionHeight, superOption.name, MENU);
            add(alpha);
            alpha.cameras = [subCamera];

            sectionHeight += 65;

            var curMenuHeight = sectionHeight;

            sectionHeight += 75;

            var optBG:FlxSprite = new FlxSprite(0, curMenuHeight + 20);
            optBG.cameras = [subCamera];
            add(optBG);

            var optHeight:Float = 0;

            for (option in superOption.options)
            {
                var opt:ControlsAlphabet = new ControlsAlphabet(curMenuHeight + optHeight, option, CATEGORY);
                add(opt);

                var keyData:Array<Null<Int>> = Reflect.field(Reflect.field(ClientPrefs.controls, superOption.name), option);

                var main:ControlsAlphabet = new ControlsAlphabet(opt.y, '', MAIN_OPTION, superOption.name, option);
                add(main);

                if (keyData[0] == 0)
                    main.setKeyText(null);
                else
                    main.setKeyText(keyData[0]);

                var alt:ControlsAlphabet = new ControlsAlphabet(opt.y, '', ALT_OPTION, superOption.name, option);
                add(alt);
                if (keyData[1] == 0)
                    alt.setKeyText(null);
                else
                    alt.setKeyText(keyData[1]);

                for (obj in [opt, main, alt])
                    obj.cameras = [subCamera];

                options.push([main, alt]);

                sectionHeight += opt.height + 39;

                optHeight += opt.height + 25;
            }

            optBG.loadGraphic(FlxGridOverlay.createGrid(Math.floor(FlxG.width * 0.8 / 2.9), Math.floor(optHeight / superOption.options.length * 1.01), Math.floor(FlxG.width * 0.8), Math.floor(optHeight), true, FlxColor.fromRGB(100, 100, 100), FlxColor.fromRGB(150, 150, 150)));
            optBG.x = FlxG.width / 2 - optBG.width / 2;
            optBG.alpha = 0.4;
        }
    }

    var curTime:Float = 0;

    var selected:ControlsAlphabet = null;

    var canSelect:Dynamic = {
        options: true,
        key: false,
        timer: 0
    };

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        curTime += elapsed;

        if (canSelect.options)
        {
            if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT)
                changeOption(FlxG.keys.justPressed.RIGHT ? 1 : FlxG.keys.justPressed.LEFT ? -1 : null, FlxG.keys.justPressed.UP ? -1 : FlxG.keys.justPressed.DOWN ? 1 : null);
            else if (Controls.MOUSE_WHEEL)
                changeOption(Controls.MOUSE_WHEEL_UP ? -1 : 1, 0);

            if (FlxG.keys.justPressed.ENTER)
            {
                canSelect.timer = 0;

                selected = options[selInt.y][selInt.x];

                selected.visible = false;
                FlxFlicker.flicker(selected, 0, 0.15);

                canSelect.options = false;
                canSelect.key = true;
            }

            if (FlxG.keys.justPressed.ESCAPE)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));

                CoolUtil.save.saveControls();

                close();
            }
        }

        if (canSelect.key)
        {
            if (canSelect.timer <= elapsed)
                canSelect.timer += elapsed;

            if (FlxG.keys.justPressed.ANY && canSelect.timer > elapsed)
            {
                selected.setKeyText(FlxG.keys.firstJustPressed());

                selected.visible = true;

                FlxFlicker.stopFlickering(selected);

                canSelect.key = false;
                canSelect.options = true;

                for (option in options)
                    for (object in option)
                        if (object != selected && object.category == selected.category && object.key == selected.key)
                            object.setKeyText(null);
            }
        }
        
        subCamera.scroll.y = CoolUtil.fpsLerp(subCamera.scroll.y, (sectionHeight + 300) / options.length * selInt.y / 2 + 50, 0.15);
    }

    function changeOption(?x:Int = 0, ?y:Int = 0)
    {
        selInt.x += x;
        
        if (selInt.x < 0)
        {
            selInt.x = 1;

            selInt.y--;
        } else if (selInt.x > 1) {
            selInt.x = 0;

            selInt.y++;
        }

        selInt.y += y;
        
        if (selInt.y < 0)
            selInt.y = options.length - 1;
        else if (selInt.y > options.length - 1)
            selInt.y = 0;

        for (index => option in options)
        {
            option[0].alpha = selInt.x == 0 && selInt.y == index ? 0.85 : 0.3;
            option[1].alpha = selInt.x == 1 && selInt.y == index ? 0.85 : 0.3;
        }
    
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    override function destroy()
    {
        FlxG.cameras.remove(subCamera);

        super.destroy();
    }
}