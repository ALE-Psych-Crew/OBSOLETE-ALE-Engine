package scripting.lua.flixel;

import flixel.FlxBasic;
import flixel.group.FlxGroup;

class LuaGroups extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('newGroup', function(tag:String, size:Int = 0)
            {
                setTag(tag, new FlxGroup(size));
            }
        );

        set('newSpriteGroup', function(tag:String, x = 0, y = 0, size = 0)
            {
                setTag(tag, new FlxSpriteGroup(x, y, size));
            }
        );

        set('addToGroup', function(groupTag:String, objectTag:String)
            {
                if ((tagIs(groupTag, FlxGroup) || tagIs(groupTag, FlxSpriteGroup)) && tagIs(objectTag, FlxBasic))
                    getTag(groupTag).add(getTag(objectTag));
            }
        );

        set('insertToGroup', function(groupTag:String, index:Int, objectTag:String)
            {
                if ((tagIs(groupTag, FlxGroup) || tagIs(groupTag, FlxSpriteGroup)) && tagIs(objectTag, FlxBasic))
                    getTag(groupTag).insert(index, getTag(objectTag));
            }
        );

        set('removeFromGroup', function(groupTag:String, objectTag:String, ?splice:Bool)
            {
                if ((tagIs(groupTag, FlxGroup) || tagIs(groupTag, FlxSpriteGroup)) && tagIs(objectTag, FlxBasic))
                    getTag(groupTag).remove(getTag(objectTag), splice);
            }
        );
    }
}