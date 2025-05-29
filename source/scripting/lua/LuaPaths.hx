package scripting.lua;

class LuaPaths extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('precacheImage', Paths.image);

        set('precacheInst', Paths.inst);

        set('precacheVoices', Paths.voices);

        set('precacheMusic', Paths.music);

        set('precacheSound', Paths.sound);

        set('getAtlas', function(tag:String, sprite:String)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).frames = Paths.getAtlas(sprite);
            }
        );

        set('getSparrowAtlas', function(tag:String, sprite:String)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).frames = Paths.getSparrowAtlas(sprite);
            }
        );

        set('getPackerAtlas', function(tag:String, sprite:String)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).frames = Paths.getPackerAtlas(sprite);
            }
        );

        set('getAsepriteAtlas', function(tag:String, sprite:String)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).frames = Paths.getAsepriteAtlas(sprite);
            }
        );
    }
}