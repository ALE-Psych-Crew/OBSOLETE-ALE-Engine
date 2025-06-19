package scripting.lua.flixel;

import funkin.visuals.objects.VideoSprite;

class LuaVideoSprite extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('newVideoSprite', function(tag:String, x:Float = 0, y:Float = 0, path:String, playOnLoad:Bool = true, loop:Bool = false, isUrl:Bool = false)
            {
                setTag(tag, new VideoSprite(x, y, isUrl ? path : Paths.video(path), playOnLoad, loop,
                    function ()
                    {
                        if (type == STATE)
                        {
                            if (ScriptState.instance != null)
                                ScriptState.instance.callOnLuaScripts('onVideoEndReached', [tag]);
                        } else {
                            if (ScriptSubState.instance != null)
                                ScriptSubState.instance.callOnLuaScripts('onVideoEndReached', [tag]);
                        }
                    }
                ));
            }
        );

        set('playVideoSprite', function(tag:String)
            {
                if (tagIs(tag, VideoSprite))
                    getTag(tag).play();
            }
        );

        set('stopVideoSprite', function(tag:String)
            {
                if (tagIs(tag, VideoSprite))
                    getTag(tag).stop();
            }
        );

        set('pauseVideoSprite', function(tag:String)
            {
                if (tagIs(tag, VideoSprite))
                    getTag(tag).pause();
            }
        );

        set('resumeVideoSprite', function(tag:String)
            {
                if (tagIs(tag, VideoSprite))
                    getTag(tag).resume();
            }
        );

        set('toggleVideoSpritePaused', function(tag:String)
            {
                if (tagIs(tag, VideoSprite))
                    getTag(tag).togglePaused();
            }
        );
    }
}