package scripting.lua;

import core.enums.PrintType;

class LuaCoolUtil extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('debugPrint', CoolUtil.debugPrint);

        set('debugTrace', CoolUtil.debugTrace);

        set('switchState', function(fullClassPath:String, params:Array<Dynamic>)
		{
			CoolUtil.switchState(Type.createInstance(Type.resolveClass(fullClassPath), params));
		});

        set('switchToCustomState', function(name:String)
		{
			CoolUtil.switchState(() -> new CustomState(name));
		});

        set('capitalize', CoolUtil.capitalize);

        set('floorDecimal', CoolUtil.floorDecimal);

        set('dominantColor', function(tag:String)
            {
                if (tagIs(tag, FlxSprite))
                    CoolUtil.dominantColor(getTag(tag));
            }
        );

        set('browserLoad', CoolUtil.browserLoad);

        set('getGameSavePath', CoolUtil.getSavePath);

        set('getCurrentState', CoolUtil.getCurrentState);

        set('getCurrentSubState', CoolUtil.getCurrentSubState);

        set('fpsLerp', CoolUtil.fpsLerp);

        set('fpsRatio', CoolUtil.fpsRatio);

        set('showPopUp', CoolUtil.showPopUp);

        set('resetEngine', CoolUtil.resetEngine);

        set('formatSongPath', CoolUtil.formatSongPath);

        set('loadSong', CoolUtil.loadSong);

        set('loadWeek', CoolUtil.loadWeek);
        
        set('resizeGame', CoolUtil.resizeGame);

        set('adjustColorBrightness', CoolUtil.adjustColorBrightness);

        set('getGameSize', function(type:String)
            {
                return switch (type.toLowerCase().trim())
                {
                    case 'y':
                        FlxG.height;
                    default:
                        FlxG.width;
                }
            }
        );
    }
}