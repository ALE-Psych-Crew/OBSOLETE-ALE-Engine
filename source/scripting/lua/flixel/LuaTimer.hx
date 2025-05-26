package scripting.lua.flixel;

import flixel.util.FlxTimer;

class LuaTimer extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('newTimer', function(tag:String)
            {
                setTag(tag, new FlxTimer());
            }
        );
        
        set('startTimer', function(tag:String, time:Float = 1, loops:Int = 1)
            {
                if (tagIs(tag, FlxTimer))
                    getTag(tag).start(time, function(_)
                        {
                            if (type == STATE)
                            {
                                if (ScriptState.instance != null)
                                    ScriptState.instance.callOnLuaScripts('onTimerComplete', [tag]);
                            } else {
                                if (ScriptSubState.instance != null)
                                    ScriptSubState.instance.callOnLuaScripts('onTimerComplete', [tag]);
                            }
                        },
                    loops);
            }  
        );

        set('cancelTimer', function(tag:String)
            {
                if (tagIs(tag, FlxTimer))
                    getTag(tag).cancel();
            }
        );

        set('resetTimer', function(tag:String, ?newTime:Float = -1)
            {
                if (tagIs(tag, FlxTimer))
                    getTag(tag).reset(newTime);
            }
        );

        set('runTimer', function(tag:String, time:Float = 1, loops:Int = 1)
            {
                new FlxTimer().start(time, function(_)
                    {
                        if (type == STATE)
                        {
                            if (ScriptState.instance != null)
                                ScriptState.instance.callOnLuaScripts('onTimerComplete', [tag]);
                        } else {
                            if (ScriptSubState.instance != null)
                                ScriptSubState.instance.callOnLuaScripts('onTimerComplete', [tag]);
                        }

                        removeTag(tag);
                    },
                loops);
            }
        );
    }
}