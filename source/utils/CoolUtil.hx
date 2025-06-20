package utils;

import lime.app.Application;

import flixel.FlxSprite;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.util.typeLimit.NextState;

import funkin.visuals.ALECamera;

import funkin.visuals.shaders.ALERuntimeShader;

import openfl.system.Capabilities;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import openfl.ui.Mouse;

import core.config.MainState;
import core.Main;
import core.backend.Mods;
import core.backend.Controls;

import core.enums.PrintType;
import core.enums.PlayStateMode;

import core.structures.*;

import utils.ALEParserHelper;

import sys.thread.Thread;

class CoolUtil
{
	public static var instance:CoolUtil;

	public function new()
	{
		instance = this;
	}

	public static var save:ALESave;

	public static function capitalize(text:String):String
		return text.charAt(0).toUpperCase() + text.substring(1).toLowerCase();

	public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if (colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
		return FlxMath.roundDecimal(value, decimals);

	public static function dominantColor(sprite:FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = new Map<Int, Int>();
		
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel != 0) {
					if (countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0;
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if (countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	public static function browserLoad(site:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	@:access(flixel.util.FlxSave.validate)
	public static function getSavePath(modSupport:Bool = true):String
	{
		final company:String = FlxG.stage.application.meta.get('company');
		
		return company + '/' + flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file')) + (modSupport ? ((Mods.folder.trim() == '' ? '' : '/' + Mods.folder)) : '');
	}

	public static function getCurrentState():String
		return FlxG.state == null ? 'null' : Type.getClassName(Type.getClass(FlxG.state));

	public static function getCurrentSubState():String
		return FlxG.state.subState == null ? 'null' : Type.getClassName(Type.getClass(FlxG.state.subState));

	public static function fpsLerp(v1:Float, v2:Float, ratio:Float):Float
		return FlxMath.lerp(v1, v2, fpsRatio(ratio));

	public static function fpsRatio(ratio:Float)
		return FlxMath.bound(ratio * FlxG.elapsed * 60, 0, 1);

	public static function showPopUp(title:String, message:String):Void
	{
		debugTrace(title + ' | ' + message, POP_UP);

		#if (windows && cpp)
		cpp.WindowsAPI.showMessageBox(title, message, INFORMATION);
		#else
		FlxG.stage.window.alert(message, title);
		#end
	}

	public static function resetEngine():Void
	{
		CoolUtil.save.savePreferences();
		CoolUtil.save.saveControls();

		resizeGame(Main.game.width, Main.game.height);

		DiscordRPC.shutdown();

		PlayState.SONG = null;
		PlayState.STAGE = null;
		PlayState.difficulty = null;
		PlayState.songRoute = null;
		PlayState.startPosition = 0;
		PlayState.mode = FREEPLAY;

		CoolVars.skipTransIn = CoolVars.skipTransOut = true;

		if (ScriptState.instance != null)
			ScriptState.instance.destroyScripts();

		if (ScriptSubState.instance != null)
			ScriptSubState.instance.destroyScripts();

		if (FlxG.state.subState != null)
			FlxG.state.subState.close();

		for (key in CoolVars.globalVars.keys())
			CoolVars.globalVars.remove(key);

		FlxG.game.removeChild(MainState.debugCounter);
		
		MainState.debugCounter.destroy();
		MainState.debugCounter = null;

        #if (windows && cpp)
		cpp.WindowsAPI.setWindowBorderColor(255, 255, 255);
		#end

		FlxTween.globalManager.clear();

		FlxG.camera.bgColor = FlxColor.BLACK;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			
			FlxG.sound.music = null;
		}

		FlxG.resetGame();
		
		Mouse.cursor = ARROW;
	}

	public static function formatSongPath(string:String):String
	{
		string = string.replace(' ', '-').toLowerCase();

		while (string.endsWith('-'))
			string.substring(0, string.length - 1);

		while (string.startsWith('-'))
			string.substring(1);

		return string;
	}

	public static function initALECamera():ALECamera
	{
		var camera = new ALECamera();
		
		FlxG.cameras.reset(camera);
		FlxG.cameras.setDefaultDrawTarget(camera, true);
		
		return camera;
	}
	
	public static function loadSong(name:String, diff:String, mode:PlayStateMode = FREEPLAY, goToPlayState:Bool = true):Void
	{
		var jsonData:Dynamic = {};

		name = formatSongPath(name);
		
		var difficulty:String = formatSongPath(diff);

		var parentFolders:Array<String> = [Paths.modFolder(), 'assets'];

		for (parentFolder in parentFolders)
		{
			if (FileSystem.exists(parentFolder + '/songs') && FileSystem.isDirectory(parentFolder + '/songs'))
			{
				for (folder in FileSystem.readDirectory(parentFolder + '/songs'))
				{
					if (name == formatSongPath(folder))
					{
						if (FileSystem.exists(parentFolder + '/songs/' + folder + '/charts/' + difficulty + '.json'))
						{
							jsonData = Json.parse(sys.io.File.getContent(parentFolder + '/songs/' + folder + '/charts/' + difficulty + '.json'));
		
							PlayState.songRoute = 'songs/' + folder;
						}
					}
				}
			}
		}

		if (jsonData == null || Reflect.fields(jsonData).length <= 0)
		{
			debugTrace('songs/' + name + '/charts/' + difficulty + '.json', MISSING_FILE);

			return;
		}

		PlayState.SONG = ALEParserHelper.getALESong(jsonData);
		PlayState.difficulty = diff;
		PlayState.mode = mode;

		if (goToPlayState)
			switchState(() -> new PlayState());
	}

	public static function loadWeek(names:Array<String>, difficulty:String)
	{
		PlayState.playlistIndex = 0;
		PlayState.playlist = names;

		loadSong(names[0], difficulty, STORY);
	}

	public static function resizeGame(width:Int, height:Int)
	{
		FlxG.fullscreen = false;

		FlxG.initialWidth = width;
		FlxG.initialHeight = height;

		FlxG.resizeGame(width, height);

		FlxG.resizeWindow(width, height);

		Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
		Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);

		for (camera in FlxG.cameras.list)
		{
			camera.width = width;
			camera.height = height;
		}
	}

	public static function adjustColorBrightness(color:FlxColor, factor:Float):FlxColor
	{
		factor /= 100;
	
		var r = (color >> 16) & 0xFF;
		var g = (color >> 8) & 0xFF;
		var b = color & 0xFF;
	
		if (factor > 0)
		{
			r += Std.int((255 - r) * factor);
			g += Std.int((255 - g) * factor);
			b += Std.int((255 - b) * factor);
		} else {
			r = Std.int(r * (1 + factor));
			g = Std.int(g * (1 + factor));
			b = Std.int(b * (1 + factor));
		}
	
		return FlxColor.fromRGB(r, g, b);
	}

    private static var iconImage:String = null;

	public static function reloadGameMetadata()
	{
		CoolVars.data = {
			developerMode: false,
			scriptsHotReloading: false,

			initialState: 'IntroState',
			freeplayState: 'FreeplayState',
			storyMenuState: 'StoryMenuState',
			masterEditorMenu: 'MasterEditorMenu',
			mainMenuState: 'MainMenuState',

			pauseSubState: 'PauseSubState',
			gameOverScreen: 'GameOverSubState',
			transition: 'FadeTransition',

			title: 'Friday Night Funkin\': ALE Engine',
			icon: 'appIcon',

			bpm: 102.0,

			discordID: '1309982575368077416',
		};

		try
		{
			if (Paths.fileExists('data.json'))
			{
				var json:Dynamic = Json.parse(File.getContent(Paths.getPath('data.json')));

				for (field in Reflect.fields(json))
					if (Reflect.hasField(CoolVars.data, field))
						Reflect.setField(CoolVars.data, field, Reflect.field(json, field));
			}
		} catch (error:Dynamic) {
			debugTrace('Error While Loading Game Data (data.json): ' + error, ERROR);
		}

		if (Paths.fileExists(CoolVars.data.icon + '.png'))
		{
			iconImage = CoolVars.data.icon;

			openfl.Lib.current.stage.window.setIcon(lime.graphics.Image.fromFile(Paths.getPath(CoolVars.data.icon + '.png')));
		} else {
			openfl.Lib.current.stage.window.setIcon(lime.graphics.Image.fromFile(Paths.getPath('images/appIcon.png')));
		}

        FlxG.stage.window.title = CoolVars.data.title;
	}

    public static function switchState(state:NextState, skipTransIn:Bool = null, skipTransOut:Bool = null)
    {
        if (state is CustomState)
        {
			var scriptName = cast(state, CustomState).scriptName;
			
            if (Paths.fileExists('scripts/states/' + scriptName + '.hx') || Paths.fileExists('scripts/states/' + scriptName + '.lua'))
                transitionSwitch(state, skipTransIn, skipTransOut);
            else
                debugPrint('Custom State called "' + scriptName + '" doesn\'t Exist', MISSING_FILE);
        } else {
			transitionSwitch(state, skipTransIn, skipTransOut);
		}
    }

	private static function transitionSwitch(state:NextState, skipTransIn:Bool = null, skipTransOut:Bool = null)
	{
		if (skipTransIn != null)
			CoolVars.skipTransIn = skipTransIn;

		if (skipTransOut != null)
			CoolVars.skipTransOut = skipTransOut; 

        if (CoolVars.skipTransIn)
		{
            CoolVars.skipTransIn = false;

			FlxG.switchState(state);
		} else {
            #if (cpp)
			CoolUtil.openSubState(new CustomSubState(
				CoolVars.data.transition,
				null,
				[
					'transIn' => true,
					'transOut' => false,
					'finishCallback' => () -> { FlxG.switchState(state); }
				],
				[
					'transIn' => true,
					'transOut' => false,
					'finishCallback' => () -> { FlxG.switchState(state); }
				]
			));
			#end
		}
	}

	public static function openSubState(subState:flixel.FlxSubState = null)
	{
		if (subState == null)
			return;

        if (subState is CustomSubState)
        {
            var custom:CustomSubState = Std.downcast(subState, CustomSubState);
            
            if (Paths.fileExists('scripts/substates/' + custom.scriptName + '.hx') || Paths.fileExists('scripts/substates/' + custom.scriptName + '.lua'))
                FlxG.state.openSubState(subState);
            else
                debugPrint('Custom SubState called "' + custom.scriptName + '" doesn\'t Exist', MISSING_FILE);

            return;
        }

		FlxG.state.openSubState(subState);
	}

	public static function debugPrint(text:Dynamic, ?type:PrintType = TRACE, ?customType:String = '', ?customColor:FlxColor = FlxColor.GRAY)
	{
		if (!CoolVars.data.developerMode)
			return;

		if (MusicBeatSubState.instance != null)
			MusicBeatSubState.instance.debugPrint(text, type, customType, customColor);
		else if (MusicBeatState.instance != null)
			MusicBeatState.instance.debugPrint(text, type, customType, customColor);
		else
			debugTrace(text, type, customType, customColor);
	}

	public static function debugTrace(text:Dynamic, ?type:PrintType = TRACE, ?customType:String = '', ?customColor:FlxColor = FlxColor.GRAY, ?pos:haxe.PosInfos)
	{
		if (!CoolVars.data.developerMode)
			return;

		text = Std.string(text);

		var theText:String = ansiColorString(type == CUSTOM ? customType : PrintType.typeToString(type), type == CUSTOM ? customColor : PrintType.typeToColor(type)) + ansiColorString(' | ' + Date.now().toString().split(' ')[1] + ' | ', 0xFF505050) + (pos == null ? '' : ansiColorString(pos.fileName + ': ', 0xFF888888)) + text;

		Sys.println(theText);
	}

	public static function ansiColorString(text:String, color:FlxColor):String
		return '\x1b[38;2;' + color.red + ';' + color.green + ';' + color.blue + 'm' + text + '\x1b[0m';

	public static function createRuntimeShader(shaderName:String):ALERuntimeShader
	{
		#if (!flash && sys)
		if (!ClientPrefs.data.shaders)
			return null;

		var frag:String = 'shaders/' + shaderName + '.frag';
		var vert:String = 'shaders/' + shaderName + '.vert';

		var found:Bool = false;

		if (Paths.fileExists(frag))
		{
			frag = File.getContent(Paths.getPath(frag));

			found = true;
		} else {
			frag = null;
		}

		if (Paths.fileExists(vert))
		{
			vert = File.getContent(Paths.getPath(vert));

			found = true;
		} else {
			vert = null;
		}

		if (found)
		{
			return new ALERuntimeShader(shaderName, frag, vert);
		} else {
			debugPrint('Missing Shader: ' + shaderName, MISSING_FILE);

			return null;
		}
		#else
		FlxG.log.warn('Platform Unsupported for Runtime Shaders');

		return null;
		#end
	}

	public static function setCameraShaders(camera:FlxCamera, shaders:Array<ALERuntimeShader>):Void
	{
		var filterArray:Array<BitmapFilter> = [];

		for (shader in shaders)
			filterArray.push(new ShaderFilter(shader));

		camera.filters = filterArray;
	}

	public static function createSafeThread(func:Void -> Void):Thread
	{
		return Thread.create(function()
		{
			try {
				func();
			} catch(e) {
				debugTrace(e.details(), ERROR);
			}
		});
	}
	
    public static function getAllDirectoryFiles(path:String):Array<String>
    {
        var result:Array<String> = [];

        if (!FileSystem.exists(path))
            return result;

        var entries = FileSystem.readDirectory(path);

        for (entry in entries)
        {
            var fullPath = path + '/' + entry;

            result.push(fullPath);

            if (FileSystem.isDirectory(fullPath))
                result = result.concat(getAllDirectoryFiles(fullPath));
        }

        return result;
    }

	public static function snapNumber(og:Float, mod:Int):Float
		return Math.floor(og / mod) * mod;
	
	public static function colorFromArray(arr:Array<Int>):Int
    	return FlxColor.fromRGB(arr[0], arr[1], arr[2]);

	public static function objectOverlaps(obj1:FlxSprite, obj2:FlxSprite)
		return obj1.x + obj1.width >= obj2.x && obj1.y + obj1.height >= obj2.y && obj1.x <= obj2.x + obj2.width && obj1.y <= obj2.y + obj2.height;
}