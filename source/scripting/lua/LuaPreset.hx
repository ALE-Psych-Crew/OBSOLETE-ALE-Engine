package scripting.lua;

import scripting.lua.flixel.*;
import scripting.lua.haxe.*;

class LuaPreset
{
    public function new(lua:LuaScript)
    {
        new LuaGlobal(lua);

        new LuaCamera(lua);
        new LuaColor(lua);
        new LuaSprite(lua);
        new LuaBackdrop(lua);
        new LuaText(lua);
        new LuaSound(lua);
        new LuaTween(lua);
        new LuaKeys(lua);
        new LuaMouse(lua);
        new LuaTimer(lua);
        new LuaGroups(lua);

        new LuaControls(lua);

        new LuaReflect(lua);
        new LuaFileSystem(lua);

        new LuaWindowsCPP(lua);
        
        new LuaCoolUtil(lua);
        new LuaPaths(lua);

        new LuaDiscord(lua);

        lua.set('this', FlxG.state);
    }
}