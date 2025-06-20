package funkin.visuals.game;

import core.enums.ALECharacterType;

import funkin.visuals.shaders.RGBPalette;
import funkin.visuals.shaders.RGBShaderReference;

class Strum extends FlxSprite
{
    public var data:Int;

	var shaderRef:RGBShaderReference;

    public var type:ALECharacterType;

    public var direction:Float = 90;

    public var scrollSpeed:Float = 1;

	public var strumLine:StrumLine;

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

		frames = Paths.getSparrowAtlas('notes/' + texture);

		var animToPlay:String = switch (data)
		{
			case 0: 'left';
			case 1: 'down';
			case 2: 'up';
			case 3: 'right';
			default: null;
		};

		animation.addByPrefix('idle', 'arrow' + animToPlay.toUpperCase(), 24, false);
		animation.addByPrefix('pressed', animToPlay + ' press', 24, false);
		animation.addByPrefix('hit', animToPlay + ' confirm', 24, false);

		animation.onFrameChange.add((name:String, frameNumber:Int, frameIndex:Int) -> {
            centerOffsets();
            centerOrigin();

			if (shaderRef != null)
				shaderRef.enabled = name != 'idle';
		});

		animation.onFinish.add((name:String) -> {
			if (name == 'hit' && strumLine.botplay)
				animation.play('idle');
		});

		scale.set(0.7, 0.7);

        updateHitbox();
        centerOffsets();
		centerOrigin();

		animation.play('idle', true);

        return texture;
    }

    override public function new(data:Int, type:ALECharacterType, strumLine:StrumLine, texture:String = 'note')
    {
        super();

        this.data = data;

		this.strumLine = strumLine;

        this.texture = texture;

		x = 160 * 0.7 * data;

		if (type == OPPONENT)
			x += 50;
		else
			x += FlxG.width - (160 * 0.7 * 5) + 50;

		y = ClientPrefs.data.downScroll ? FlxG.height - 150 : 50;

		var rgbPalette = new RGBPalette();

		shaderRef = new RGBShaderReference(this, rgbPalette);

		var shaderArray:Array<FlxColor> = ClientPrefs.data.arrowRGB[data % 4];

		shaderRef.r = shaderArray[0];
		shaderRef.g = shaderArray[1];
		shaderRef.b = shaderArray[2];

		antialiasing = ClientPrefs.data.antialiasing;

		animation.play('idle', true);
    }
}