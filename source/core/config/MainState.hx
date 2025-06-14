package core.config;

import utils.ALESave;

import funkin.debug.DebugCounter;

import flixel.input.keyboard.FlxKey;

import haxe.io.Path;

import core.backend.Mods;

/**
 * Used to configure and add the necessary elements before starting the game
 */
class MainState extends flixel.FlxState
{
    #if mobile
    private var showedModMenu:Bool = false;
    #end

    public static var debugCounter:DebugCounter;

    override function create()
    {
        CoolVars.skipTransOut = true;
        
        openalFix();

		FlxG.fixedTimestep = false;
        
		FlxG.game.focusLostFramerate = 60;

		FlxG.keys.preventDefaultKeys = [TAB, SHIFT, ALT, CONTROL];

		FlxG.sound.muteKeys = [ZERO];
		FlxG.sound.volumeDownKeys = [NUMPADMINUS, MINUS];
		FlxG.sound.volumeUpKeys = [NUMPADPLUS, PLUS];

        Mods.init();
    
        if (CoolUtil.save == null)
            CoolUtil.save = new ALESave();
        
        CoolUtil.save.loadPreferences();
        CoolUtil.save.loadControls();

        CoolVars.engineVersion = lime.app.Application.current.meta.get('version');

        CoolUtil.reloadGameMetadata();

        DiscordRPC.initialize(CoolVars.data.discordID);

        debugCounter = new DebugCounter();
        
        FlxG.stage.addChild(debugCounter);

        #if cpp
        if (ClientPrefs.data.openConsoleOnStart)
            cpp.WindowsTerminalCPP.allocConsole();
        #end

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end

		if (ClientPrefs.data.checkForUpdates)
        {
			var http = new haxe.Http('https://raw.githubusercontent.com/ALE-Engine-Crew/ALE-Engine/refs/heads/main/version.txt');

			http.onData = function (data:String)
			{
                var onlineVersion:String = data.split('\n')[0].trim();

				if (onlineVersion != CoolVars.engineVersion)
                {
					CoolVars.mustUpdate = true;

                    debugCounter.showUpdatePopup(onlineVersion);
                }
			}

			http.onError = function (error)
            {
				debugTrace('Error During Update Checkout: ' + error, ERROR);
			}

			http.request();
		}

        super.create();

        #if mobile
        if (!showedModMenu)
        {
            CoolUtil.openSubState(new funkin.substates.ModsMenuSubState());

            showedModMenu = true;
        }
        #end
        
        CoolUtil.switchState(() -> new CustomState(CoolVars.data.initialState), true, true);
    }

    function openalFix()
    {
		#if desktop
		var origin:String = #if hl Sys.getCwd() #else Sys.programPath() #end;

		var configPath:String = Path.directory(Path.withoutExtension(origin));

		#if windows
		configPath += "/plugins/alsoft.ini";
		#elseif mac
		configPath = Path.directory(configPath) + "/Resources/plugins/alsoft.conf";
		#else
		configPath += "/plugins/alsoft.conf";
		#end

		Sys.putEnv("ALSOFT_CONF", configPath);
		#end	
    }
}