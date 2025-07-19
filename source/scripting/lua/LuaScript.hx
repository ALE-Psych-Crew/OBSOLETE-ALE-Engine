package scripting.lua;

#if LUA_ALLOWED
import llua.*;
import llua.Lua.Lua_helper;

import haxe.ds.StringMap;

import core.enums.ScriptType;

class LuaScript
{   
    public var lua:State = null;

    public var type:ScriptType;

    public var name:String;

    public var closed:Bool = false;

    public var callbacks:StringMap<Dynamic> = new StringMap<Dynamic>();
    public var variables:StringMap<Dynamic> = new StringMap<Dynamic>();

    public function new(name:String, type:ScriptType)
    {
        this.name = name;

        this.type = type;

        config();
    }

    function config()
    {
        lua = LuaL.newstate();
        
        LuaL.openlibs(lua);

        var result = LuaL.dofile(lua, name);

        var resultString:String = Lua.tostring(lua, result);
        
        if (resultString != null && result != 0)
            debugPrint('Error on Lua Script: ' + resultString, ERROR);

        new LuaPreset(this);
    }

    public function set(name:String, value:Dynamic)
    {
        if (lua == null || closed)
            return;

        Convert.toLua(lua, value);

        Lua.setglobal(lua, name);
    }
    
    public function setFunction(name:String, theFunction:Dynamic)
    {
        callbacks.set(name, theFunction);
        Lua_helper.add_callback(lua, name, null);
    }

    public static var lastCalledScript:LuaScript = null;

    public function call(name:String, ?args:Array<Dynamic>):Dynamic
    {
        if (closed)
            return null;

        LuaCallbackHandler.type = type;

        lastCalledScript = this;

        try
        {
            if (lua == null)
                return null;

            Lua.getglobal(lua, name);

            var theType:Int = Lua.type(lua, -1);

            if (theType != Lua.LUA_TFUNCTION)
            {
                if (theType > Lua.LUA_TNIL)
                    debugPrint('Error: (' + name + '): Attempt to Call a ' + typeToString(theType) + ' value', ERROR);

                Lua.pop(lua, 1);
                
                return null;
            }
            
            if (args != null)
                for (arg in args)
                    Convert.toLua(lua, arg);

            var status:Int = Lua.pcall(lua, args == null ? 0 : args.length, 1, 0);

            if (status != Lua.LUA_OK)
            {
                debugPrint('Error (' + name + '): ' + getError(status), ERROR);

                return null;
            }
            
            var result:Dynamic = null;

            if (Lua.gettop(lua) > 0)
            {
                result = cast Convert.fromLua(lua, -1);
                
                Lua.pop(lua, 1);
            }

            if (closed)
                close();

            return result;
        } catch (error:Dynamic) {
            debugPrint(error, ERROR);
        }

        return null;
    }

    public function close()
    {
        closed = true;

        if (lua == null || closed)
            return;

        Lua.close(lua);
    }

    private function typeToString(type:Int):String
    {
        return switch (type)
        {
            case Lua.LUA_TBOOLEAN:
                'bool';
            case Lua.LUA_TNUMBER:
                'number';
            case Lua.LUA_TSTRING:
                'string';
            case Lua.LUA_TTABLE:
                'table';
            case Lua.LUA_TFUNCTION:
                'function';
            case Lua.LUA_TNIL:
                'null';
            default:
                'unknown';
        }
    }

    private function getError(status:Int):String
    {
        var value:String = Lua.tostring(lua, -1);

        Lua.pop(lua, 1);

        if (value != null)
            value = value.trim();

        if (value == null || value == '')
        {
            return switch (status)
            {
                case Lua.LUA_ERRRUN:
                    'Runtime Error';
                case Lua.LUA_ERRMEM:
                    'Memory Allocation Error';
                case Lua.LUA_ERRERR:
                    'Critical Error';
                default:
                    'Unknown Error';
            }
        }

        return value;

        return null;
    }
}
#end