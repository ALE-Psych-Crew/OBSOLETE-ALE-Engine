package scripting.lua;

import scripting.lua.flixel.*;
import scripting.lua.haxe.*;

class LuaPreset
{
    public function new(lua:LuaScript)
    {
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
        new LuaState(lua);
        new LuaObject(lua);
        new LuaShader(lua);

        new LuaControls(lua);

        new LuaReflect(lua);
        new LuaFileSystem(lua);

        new LuaWindowsAPI(lua);
        
        new LuaCoolUtil(lua);
        new LuaPaths(lua);

        new LuaDiscord(lua);

        new LuaVideoSprite(lua);

        lua.set('this', FlxG.state);
    }
}