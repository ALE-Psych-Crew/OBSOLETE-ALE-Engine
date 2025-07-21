package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
#if flash
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
#end

/**
 * The flixel sound tray, the little volume meter that pops down sometimes.
 * Accessed via `FlxG.game.soundTray` or `FlxG.sound.soundTray`.
 */
@:allow(flixel.system.frontEnds.SoundFrontEnd)
class FlxSoundTray extends Sprite
{
	public var active:Bool;

	var _label:TextField;
	
	var _bg:Bitmap;
	
	var _timer:Float;

	var _bars:Array<Bitmap>;
	
	var _minWidth:Int = 80;

	var _defaultScale:Float = 2.0;

	public var sound:FlxSoundAsset = 'tick';

	public var silent:Bool = false;

	public var _y:Float;

	public var _alpha:Float = 1;

	@:keep
	public function new()
	{
		super();

		visible = false;
		scaleX = _defaultScale;
		scaleY = _defaultScale;
		_bg = new Bitmap(new BitmapData(_minWidth, 30, true, 0x7F000000));
		screenCenter();
		addChild(_bg);

		_label = new TextField();
		_label.width = _bg.width;
		
		_label.multiline = true;
		
		_label.selectable = false;

		#if flash
		_label.embedFonts = true;
		_label.antiAliasType = AntiAliasType.NORMAL;
		_label.gridFitType = GridFitType.PIXEL;
		#end

		var dtf:TextFormat = new TextFormat(Paths.font('rajdhani.ttf'), 10, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		_label.defaultTextFormat = dtf;
		addChild(_label);
		_label.text = "VOLUME";
		_label.y = 16;


		_bars = new Array();

		var tmp:Bitmap;

		for (i in 0...10)
		{
			tmp = new Bitmap(new BitmapData(4, i + 1, false, FlxColor.WHITE));
			addChild(tmp);
			_bars.push(tmp);
		}

		updateSize();

		y = -height;
		visible = false;

		Lib.application.window.onClose.add(function()
			{
				if (FlxG.save.isBound)
				{
					FlxG.save.data.mute = FlxG.sound.muted;
					FlxG.save.data.volume = FlxG.sound.volume;
					FlxG.save.flush();
				}
			}
		);
	}
	
	public function update(elapsed:Float):Void
	{
		y = CoolUtil.fpsLerp(y, _y, 0.15);

		alpha = CoolUtil.fpsLerp(alpha, _alpha, 0.15);
		
		if (_timer > 0)
		{
			_timer -= elapsed / 750;
		} else if (Math.floor(y) > -height) {
			_y = -height;

			_alpha = 0;
		}

		visible = active = Math.floor(y) >= -height;
	}
	
	public function showAnim(volume:Float, duration = 1.25, label = 'VOLUME')
	{
		if (!silent)
			FlxG.sound.play(Paths.sound('tick'), 0.75);

		_timer = duration;

		_y = 0;

		_alpha = 1;

		visible = true;

		active = true;

		final numBars = Math.round(volume * 10);

		for (i in 0..._bars.length)
			_bars[i].alpha = i < numBars ? 1.0 : 0.5;

		_label.text = label;

		updateSize();
	}
	
	function showIncrement():Void
	{
		final volume = FlxG.sound.muted ? 0 : FlxG.sound.volume;

		showAnim(volume);
	}
	
	function showDecrement():Void
	{
		final volume = FlxG.sound.muted ? 0 : FlxG.sound.volume;

		showAnim(volume);
	}

	public function screenCenter():Void
	{
		scaleX = _defaultScale;
		scaleY = _defaultScale;

		x = 0.5 * (Lib.current.stage.stageWidth - _bg.width * _defaultScale) - FlxG.game.x;
	}
	
	function updateSize()
	{
		if (_label.textWidth + 10 > _bg.width)
			_label.width = _label.textWidth + 10;
			
		_bg.width = _label.textWidth + 10 > _minWidth ? _label.textWidth + 10 : _minWidth;
		
		_label.width = _bg.width;
		
		var bx:Int = Std.int(_bg.width / 2 - 30);
		var by:Int = 14;
		for (i in 0..._bars.length)
		{
			_bars[i].x = bx;
			_bars[i].y = by;
			bx += 6;
			by--;
		}
		
		screenCenter();
	}
}
#end
