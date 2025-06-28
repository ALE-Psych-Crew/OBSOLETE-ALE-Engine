package core.backend;

import scripting.haxe.HScript;
import scripting.lua.LuaScript;

import haxe.Exception;

class ScriptState extends MusicBeatState
{
    public static var instance:ScriptState;

    private static var requestedCancel:Bool = false;
    
    override public function new()
    {
        super();

        requestedCancel = false;
    }

    #if HSCRIPT_ALLOWED
    public var hScripts:Array<HScript> = [];
    #end

    #if LUA_ALLOWED
    public var luaScripts:Array<LuaScript> = [];
    #end

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

    override public function create()
    {
        super.create();
        
        instance = this;
        
		camGame = CoolUtil.initALECamera();

		camHUD = new FlxCamera();
		camHUD.bgColor = FlxColor.TRANSPARENT;
		
		FlxG.cameras.add(camHUD, false);
    }

    override public function destroy()
    {
        instance = null;

        super.destroy();
    }

    public function loadScript(path:String)
    {
        #if HSCRIPT_ALLOWED
        if (path.endsWith('.hx'))
        {
            loadHScript(path.substring(0, path.length - 3));

            return;
        }
        #end

        #if LUA_ALLOWED
        if (path.endsWith('.lua'))
        {
            loadLuaScript(path.substring(0, path.length - 4));

            return;
        }
        #end

        #if HSCRIPT_ALLOWED
        loadHScript(path);
        #end

        #if LUA_ALLOWED
        loadLuaScript(path);
        #end
    }

    public function loadHScript(path:String)
    {
        #if HSCRIPT_ALLOWED
        if (Paths.fileExists(path + '.hx'))
        {
            var script:HScript = new HScript(Paths.getPath(path + '.hx'), STATE);

            if (!script.failedParsing)
            {
                hScripts.push(script);

                debugTrace('"' + path + '.hx" has been Successfully Loaded', HSCRIPT);
            }
        }
        #end
    }

    public function loadLuaScript(path:String)
    {
        #if LUA_ALLOWED
        if (Paths.fileExists(path + '.lua'))
        {
            var script:LuaScript = new LuaScript(Paths.getPath(path + '.lua'), STATE);

            try
            {
                luaScripts.push(script);

                debugTrace('"' + path + '.lua" has been Successfully Loaded', LUA);
            } catch (error:Exception) {
                debugPrint('Error: ' + error.details(), ERROR);
            }
        }
        #end
    }

    public function setOnScripts(name:String, value:Dynamic)
    {
        #if HSCRIPT_ALLOWED
        setOnHScripts(name, value);
        #end

        #if LUA_ALLOWED
        setOnLuaScripts(name, value);
        #end
    }

    public function setOnHScripts(name:String, value:Dynamic)
    {
        #if HSCRIPT_ALLOWED
        if (hScripts.length > 0)
            for (script in hScripts)
                script.set(name, value);
        #end
    }

    public function setOnLuaScripts(name:String, value:Dynamic)
    {
        #if LUA_ALLOWED
        if (luaScripts.length > 0)
        {
            for (script in luaScripts)
            {
                if (Reflect.isFunction(value))
                    script.setFunction(name, value);
                else
                    script.set(name, value);
            }
        }
        #end
    }

    public function callOnScripts(callback:String, ?arguments:Array<Dynamic> = null)
    {
        #if HSCRIPT_ALLOWED
        callOnHScripts(callback, arguments);
        #end

        #if LUA_ALLOWED
        callOnLuaScripts(callback, arguments);
        #end
    }

    public function callOnHScripts(callback:String, arguments:Array<Dynamic> = null)
    {
        #if HSCRIPT_ALLOWED
        if (hScripts.length > 0)
        {
            try
            {
                for (script in hScripts)
                {
                    if (script == null)
                        continue;

                    script.call(callback, arguments);
                }
            } catch(_) {}
        }
        #end
    }

    public function callOnLuaScripts(callback:String, arguments:Array<Dynamic> = null)
    {
        #if LUA_ALLOWED
        if (luaScripts.length > 0)
        {
            try
            {
                for (script in luaScripts)
                {
                    if (script == null)
                        continue;

                    script.call(callback, arguments);
                }
            } catch(_) {}
        }
        #end
    }

    public function destroyScripts()
    {
        #if HSCRIPT_ALLOWED
        destroyHScripts();
        #end

        #if LUA_ALLOWED
        destroyLuaScripts();
        #end
    }

    public function destroyHScripts()
    {
        #if HSCRIPT_ALLOWED
        if (hScripts.length > 0)
        {
            for (script in hScripts)
                hScripts.remove(script);
        }
        #end
    }

    public function destroyLuaScripts()
    {
        #if LUA_ALLOWED
        if (luaScripts.length > 0)
        {
            for (script in luaScripts)
            {
                script.close();

                luaScripts.remove(script);
            }
        }
        #end
    }

    public function runCancelable(call:String, hArgs:Array<Dynamic>, lArgs:Array<Dynamic>, func:Dynamic)
    {
        requestedCancel = false;
        
        if (lArgs != null && hArgs == null)
            hArgs = lArgs;

        if (lArgs == null && hArgs != null)
            lArgs = hArgs;

        callOnHScripts(call, hArgs);

        callOnLuaScripts(call, lArgs);

        if (!requestedCancel && func != null && Reflect.isFunction(func))
            func();

        requestedCancel = false;
    }

    @:allow(utils.scripting.haxe.HScript)
    @:allow(utils.scripting.lua.LuaScript)
    private function CancelSuperFunction():Void
        requestedCancel = true;
}