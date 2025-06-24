package core;

import lime.app.Application;

#if android
import extension.androidtools.content.Context;
import extension.androidtools.os.Environment as AndroidEnvironment;
import extension.androidtools.Permissions as AndroidPermissions;
import extension.androidtools.os.Build.VERSION as AndroidVersion;
import extension.androidtools.Settings as AndroidSettings;
import extension.androidtools.os.Build.VERSION_CODES as AndroidVersionCode;

import lime.system.System as LimeSystem;
#end

import haxe.io.Path;

import flixel.FlxGame;
import openfl.display.Sprite;

import core.config.MainState;
import core.config.CopyState;

import openfl.Lib;
import openfl.events.Event;

import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;

import openfl.Lib;

#if (windows && cpp)
@:buildXml('
<target id="haxe">
	<lib name="wininet.lib" if="windows" />
	<lib name="dwmapi.lib" if="windows" />
</target>
')

@:cppFileCode('
#include <windows.h>
#include <winuser.h>
#pragma comment(lib, "Shell32.lib")
extern "C" HRESULT WINAPI SetCurrentProcessExplicitAppUserModelID(PCWSTR AppID);
')
#end

#if linux
import lime.graphics.Image;

@:cppInclude('./cpp/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	@:allow(utils.CoolUtil)
	private static var game = {
		width: 1280,
		height: 720,
		initialState: #if mobile CopyState #else MainState #end,
		zoom: -1.0,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public static function main():Void
	{
		Lib.current.addChild(new Main());

		Lib.application.window.onClose.add(function()
			{
				CoolUtil.save.savePreferences();
			}
		);
	}

	public function new()
	{
		super();

		#if (windows && cpp)
		untyped __cpp__("SetProcessDPIAware();");

		FlxG.stage.window.borderless = true;
		FlxG.stage.window.borderless = false;

		Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
		Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);
		#end

		#if mobile
		// requestPermissions();
		
		var dir:String = Context.getExternalFilesDir();

		if (!FileSystem.exists(dir))
			FileSystem.createDirectory(dir);

		Sys.setCwd(Path.addTrailingSlash(dir));
		#end

		if (stage == null)
			addEventListener(Event.ADDED_TO_STAGE, init);
		else
			init();
	}

	private function init(?event:Event):Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);

		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			#if mobile
			game.zoom = 1.0;
			#else
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;

			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
			#end
		}

		#if LUA_ALLOWED
		llua.Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(scripting.lua.LuaCallbackHandler.call));
		#end

		addChild(new FlxGame(game.width, game.height, game.initialState, game.framerate, game.framerate, game.skipSplash, game.startFullscreen));
		
		#if linux
		openfl.Lib.current.stage.window.setIcon(lime.graphics.Image.fromFile(Paths.getPath('images/appIcon.png')));
		#end

		#if html5
		FlxG.autoPause = false;
		#end

		FlxG.mouse.useSystemCursor = true;

		FlxG.signals.gameResized.add(function (width:Float, height:Float)
			{
				if (FlxG.cameras != null)
				{
					for (cam in FlxG.cameras.list)
					{
						if (cam != null && cam.filters != null)
						{
							resetSpriteCache(cam.flashSprite);
						}
					}
				}

				if (FlxG.game != null)
					resetSpriteCache(FlxG.game);
	   		}
	   );
	}
	
	private static function resetSpriteCache(sprite:Sprite):Void
	{
		@:privateAccess
		{
		    sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}
	
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;
	
		#if (windows && cpp)
		cpp.WindowsAPI.showMessageBox('ALE Engine ' + CoolVars.engineVersion + ' | Crash Handler', errMsg, ERROR);
		#else
		Application.current.window.alert(errMsg, 'ALE Engine ' + CoolVars.engineVersion + ' | Crash Handler');
		#end

		debugTrace(errMsg, ERROR);

		DiscordRPC.shutdown();

		Sys.exit(1);
	}
	
	#if mobile
	public static function requestPermissions():Void
	{
		var isAPI33 = AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU;

		debugTrace("Check Permissions...", CUSTOM, 'ANDROID', FlxColor.LIME);
		
		if (!isAPI33)
		{
			debugTrace('Requesting EXTERNAL_STORAGE...', CUSTOM, 'ANDROID', FlxColor.LIME);

			AndroidPermissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);
		}

		if (!AndroidEnvironment.isExternalStorageManager())
			AndroidSettings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');

		var has_MANAGE_EXTERNAL_STORAGE = AndroidEnvironment.isExternalStorageManager();

		var has_READ_EXTERNAL_STORAGE = AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_EXTERNAL_STORAGE');
		
		if ((isAPI33 && !has_MANAGE_EXTERNAL_STORAGE) || (!isAPI33 && !has_READ_EXTERNAL_STORAGE))
			CoolUtil.showPopUp('Notice', 'If you accepted the permissions you are all good!' + '\nIf you didn\'t then expect a crash' + '\nPress OK to see what happens');

		debugTrace('Checking Game Directory...', CUSTOM, 'ANDROID', FlxColor.LIME);

		try
		{
			if (!FileSystem.exists(Context.getExternalFilesDir()))
				FileSystem.createDirectory(Context.getExternalFilesDir());
		} catch (e:Dynamic) {
			CoolUtil.showPopUp('Error', 'Please create directory to\n' + Context.getExternalFilesDir() + '\nPress OK to close the game');

			LimeSystem.exit(1);
		}
	}
	#end
}