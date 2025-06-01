package scripting.lua.haxe;

import Type.ValueType;

import haxe.Constraints;
import haxe.ds.StringMap;

class LuaReflect extends LuaPresetBase
{
	static final instanceStr:Dynamic = "##LUA_STRINGTOOBJ";

    override public function new(lua:LuaScript)
    {
        super(lua);

        set("getProperty", function(variable:String, ?allowMaps:Bool = false)
            {
                var split:Array<String> = variable.split('.');

                if (split.length > 1)
                    return getVarInArray(lua, getPropertyLoop(lua, split, true, allowMaps), split[split.length-1], allowMaps);

                return getVarInArray(lua, type == STATE ? ScriptState.instance : ScriptSubState.instance, variable, allowMaps);
            }
        );

        set('setProperty', (tag:String, properties:Dynamic) ->
        {
            var obj = parseVariable(lua, tag);

            if (obj != null)
                applyProps(obj, properties);
        });

        set("getPropertyFromClass", function(classVar:String, variable:String, ?allowMaps:Bool = false)
            {
                var myClass:Dynamic = Type.resolveClass(classVar);

                if (myClass == null)
                {
                    errorPrint('getPropertyFromClass: Class $classVar not found');

                    return null;
                }
    
                var split:Array<String> = variable.split('.');

                if (split.length > 1)
                {
                    var obj:Dynamic = getVarInArray(lua, myClass, split[0], allowMaps);

                    for (i in 1...split.length-1)
                        obj = getVarInArray(lua, obj, split[i], allowMaps);
    
                    return getVarInArray(lua, obj, split[split.length-1], allowMaps);
                }

                return getVarInArray(lua, myClass, variable, allowMaps);
            }
        );

        set('setPropertyFromClass', function(classVar:String, variables:Dynamic)
            {
                var myClass:Dynamic = Type.resolveClass(classVar);
            
                if (myClass == null)
                {
                    debugPrint('Class "' + classVar + '" not found', ERROR);
            
                    return null;
                }
            
                applyProps(myClass, variables);
    
                return variables;
            }
        );

        set("getPropertyFromGroup", function(obj:String, index:Int, variable:Dynamic, ?allowMaps:Bool = false)
            {
                var split:Array<String> = obj.split('.');

                var realObject:Dynamic = null;

                if (split.length > 1)
                    realObject = getPropertyLoop(lua, split, false, allowMaps);
                else
                    realObject = Reflect.getProperty(type == STATE ? ScriptState.instance : ScriptSubState.instance, obj);
    
                if (Std.isOfType(realObject, FlxTypedGroup))
                {
                    var result:Dynamic = getGroupStuff(realObject.members[index], variable, allowMaps);
                    
                    return result;
                }
    
                var leArray:Dynamic = realObject[index];

                if (leArray != null)
                {
                    var result:Dynamic = null;

                    if (Type.typeof(variable) == ValueType.TInt)
                        result = leArray[variable];
                    else
                        result = getGroupStuff(leArray, variable, allowMaps);

                    return result;
                }
                
                errorPrint("getPropertyFromGroup: Object #" + index + " from group: " + obj + " doesn't exist!");

                return null;
            }
        );

        set("setPropertyFromGroup", function(obj:String, index:Int, variable:Dynamic, value:Dynamic, ?allowMaps:Bool = false)
            {
                var split:Array<String> = obj.split('.');

                var realObject:Dynamic = null;

                if (split.length > 1)
                    realObject = getPropertyLoop(lua, split, false, allowMaps);
                else
                    realObject = Reflect.getProperty(type == STATE ? ScriptState.instance : ScriptSubState.instance, obj);
    
                if (Std.isOfType(realObject, FlxTypedGroup))
                {
                    setGroupStuff(realObject.members[index], variable, value, allowMaps);

                    return value;
                }
    
                var leArray:Dynamic = realObject[index];

                if (leArray != null)
                {
                    if (Type.typeof(variable) == ValueType.TInt)
                    {
                        leArray[variable] = value;

                        return value;
                    }

                    setGroupStuff(leArray, variable, value, allowMaps);
                }

                return value;
            }
        );

        set("removeFromGroup", function(obj:String, index:Int, dontDestroy:Bool = false)
            {
                var groupOrArray:Dynamic = Reflect.getProperty(type == STATE ? ScriptState.instance : ScriptSubState.instance, obj);

                if (Std.isOfType(groupOrArray, FlxTypedGroup))
                {
                    var obj:Dynamic = groupOrArray.members[index];

                    if (!dontDestroy)
                        obj.kill();

                    groupOrArray.remove(obj, true);

                    if (!dontDestroy)
                        obj.destroy();

                    return;
                }

                groupOrArray.remove(groupOrArray[index]);
            }
        );
            
        set("callMethod", function(funcToRun:String, ?args:Array<Dynamic> = null)
            {
                return callMethodFromObject(PlayState.instance, funcToRun, parseInstances(args));
                
            }
        );
        set("callMethodFromClass", function(className:String, funcToRun:String, ?args:Array<Dynamic> = null)
            {
                return callMethodFromObject(Type.resolveClass(className), funcToRun, parseInstances(args));
            }
        );
    
        set("createInstance", function(variableToSave:String, className:String, ?args:Array<Dynamic> = null)
            {
                variableToSave = variableToSave.trim().replace('.', '');

                if (!variables.exists(variableToSave))
                {
                    if (args == null)
                        args = [];

                    var myType:Dynamic = Type.resolveClass(className);
            
                    if (myType == null)
                    {
                        errorPrint('createInstance: Variable $variableToSave is already being used and cannot be replaced!');

                        return false;
                    }
    
                    var obj:Dynamic = Type.createInstance(myType, args);

                    if (obj != null)
                        variables.set(variableToSave, obj);
                    else
                        errorPrint('createInstance: Failed to create $variableToSave, arguments are possibly wrong.');
    
                    return (obj != null);
                } else {
                    errorPrint('createInstance: Variable $variableToSave is already being used and cannot be replaced!');
                }

                return false;
            }
        );

        set("instanceArg", function(instanceName:String, ?className:String = null)
            {
                var retStr:String ='$instanceStr::$instanceName';

                if (className != null) retStr += '::$className';

                return retStr;
            }
        );
    }

    public static function applyProps(obj:Dynamic, props:Dynamic)
    {
        for (key in Reflect.fields(props))
        {
            var value:Dynamic = Reflect.field(props, key);

            if (Reflect.fields(value).length > 0)
            {
                var subObj = Reflect.field(obj, key);

                applyProps(subObj, value);
            } else {
                Reflect.setProperty(obj, key, value);
            }
        }
    }

    public static function parseVariable(lua:LuaScript, vars:String)
    {
        var variables:Array<String> = vars.split('.');
        var prop:Dynamic = LuaReflect.getObjectDirectly(lua, variables[0]);

        if (variables.length > 1)
            prop = LuaReflect.getVarInArray(lua, LuaReflect.getPropertyLoop(lua, variables), variables[variables.length - 1]);

        return prop;
    }
    
    function parseInstances(args:Array<Dynamic>)
    {
        for (i in 0...args.length)
        {
            var myArg:String = cast args[i];

            if (myArg != null && myArg.length > instanceStr.length)
            {
                var index:Int = myArg.indexOf('::');

                if (index > -1)
                {
                    myArg = myArg.substring(index + 2);

                    var lastIndex:Int = myArg.lastIndexOf('::');

                    var split:Array<String> = myArg.split('.');

                    args[i] = (lastIndex > -1) ? Type.resolveClass(myArg.substring(0, lastIndex)) : ScriptState.instance;

                    for (j in 0...split.length)
                        args[i] = getVarInArray(lua, args[i], split[j].trim());
                }
            }
        }

        return args;
    }

    function callMethodFromObject(classObj:Dynamic, funcStr:String, args:Array<Dynamic> = null)
    {
        if (args == null)
            args = [];

        var split:Array<String> = funcStr.split('.');

        var funcToRun:Function = null;

        var obj:Dynamic = classObj;
        
        if (obj == null)
            return null;

        for (i in 0...split.length)
            obj = getVarInArray(lua, obj, split[i].trim());

        funcToRun = cast obj;
        
        return funcToRun != null ? Reflect.callMethod(obj, funcToRun, args) : null;
    }

    function setVarInArray(lua:LuaScript, instance:Dynamic, variable:String, value:Dynamic, allowMaps:Bool = false):Any
    {
        var splitProps:Array<String> = variable.split('[');

        if (splitProps.length > 1)
        {
            var target:Dynamic = null;

            if (lua.variables.exists(splitProps[0]))
            {
                var retVal:Dynamic = lua.variables.get(splitProps[0]);
                
                if (retVal != null)
                    target = retVal;
            } else {
                target = Reflect.getProperty(instance, splitProps[0]);
            }

            for (i in 1...splitProps.length)
            {
                var j:Dynamic = splitProps[i].substr(0, splitProps[i].length - 1);

                if (i >= splitProps.length-1)
                    target[j] = value;
                else
                    target = target[j];
            }

            return target;
        }

        if (allowMaps && isMap(instance))
        {
            instance.set(variable, value);

            return value;
        }

        if (lua.variables.exists(variable))
        {
            lua.variables.set(variable, value);

            return value;
        }

        Reflect.setProperty(instance, variable, value);

        return value;
    }

    public static function getVarInArray(lua:LuaScript, instance:Dynamic, variable:String, allowMaps:Bool = false):Any
    {
        var splitProps:Array<String> = variable.split('[');

        if (splitProps.length > 1)
        {
            var target:Dynamic = null;

            if (lua.variables.exists(splitProps[0]))
            {
                var retVal:Dynamic = lua.variables.get(splitProps[0]);

                if (retVal != null)
                    target = retVal;
            } else {
                target = Reflect.getProperty(instance, splitProps[0]);
            }

            for (i in 1...splitProps.length)
            {
                var j:Dynamic = splitProps[i].substr(0, splitProps[i].length - 1);

                target = target[j];
            }

            return target;
        }
        
        if (allowMaps && isMap(instance))
            return instance.get(variable);

        if (lua.variables.exists(variable))
        {
            var retVal:Dynamic = lua.variables.get(variable);

            if (retVal != null)
                return retVal;
        }

        return Reflect.getProperty(instance, variable);
    }

	function setGroupStuff(leArray:Dynamic, variable:String, value:Dynamic, ?allowMaps:Bool = false) {
		var split:Array<String> = variable.split('.');

		if (split.length > 1)
        {
			var obj:Dynamic = Reflect.getProperty(leArray, split[0]);

			for (i in 1...split.length-1)
				obj = Reflect.getProperty(obj, split[i]);

			leArray = obj;

			variable = split[split.length-1];
		}

		if (allowMaps && isMap(leArray))
            leArray.set(variable, value);
		else
            Reflect.setProperty(leArray, variable, value);

		return value;
	}

	function getGroupStuff(leArray:Dynamic, variable:String, ?allowMaps:Bool = false) {
		var split:Array<String> = variable.split('.');

		if (split.length > 1)
        {
			var obj:Dynamic = Reflect.getProperty(leArray, split[0]);

			for (i in 1...split.length-1)
				obj = Reflect.getProperty(obj, split[i]);

			leArray = obj;

			variable = split[split.length-1];
		}

		if (allowMaps && isMap(leArray))
            return leArray.get(variable);

		return Reflect.getProperty(leArray, variable);
	}

	public static function getPropertyLoop(lua:LuaScript, split:Array<String>,?getProperty:Bool=true, ?allowMaps:Bool = false):Dynamic
	{
		var obj:Dynamic = getObjectDirectly(lua, split[0]);

		var end = split.length;

		if (getProperty)
            end = split.length-1;

		for (i in 1...end)
            obj = getVarInArray(lua, obj, split[i], allowMaps);

		return obj;
	}

	static function isMap(variable:Dynamic)
	{
		if (variable.exists != null && variable.keyValueIterator != null)
            return true;

		return false;
	}

	public static function getObjectDirectly(lua:LuaScript, objectName:String, ?allowMaps:Bool = false):Dynamic
	{
		switch(objectName)
		{
			case 'this' | 'instance' | 'game':
				return lua.type == STATE ? ScriptState.instance : ScriptSubState.instance;
			
			default:
				var obj:Dynamic = lua.variables.get(objectName);

				if (obj == null)
                    obj = getVarInArray(lua, lua.type == STATE ? ScriptState.instance : ScriptSubState.instance, objectName, allowMaps);

				return obj;
		}
	}

	public static function formatVariable(tag:String)
		return tag.trim().replace(' ', '_').replace('.', '');
}