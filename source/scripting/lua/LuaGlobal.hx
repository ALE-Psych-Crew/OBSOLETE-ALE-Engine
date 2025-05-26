package scripting.lua;

import flixel.FlxBasic;
import flixel.FlxObject;

import scripting.lua.flixel.LuaCamera;

import core.enums.PrintType;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;

@:access(core.backend.ScriptState)
@:access(core.backend.ScriptSubState)
class LuaGlobal extends LuaPresetBase
{
    public function new(lua:LuaScript)
    {
        super(lua);

        set('CancelSuperFunction', type == STATE ? ScriptState.instance.CancelSuperFunction : ScriptSubState.instance.CancelSuperFunction);

        set('add', function(tag:String)
        {
            if (tagIs(tag, FlxBasic))
            {
                if (type == STATE)
                    FlxG.state.add(getTag(tag));
                else
                    FlxG.state.subState.add(getTag(tag));
            }
        });

        set('remove', function(tag:String, ?splice:Bool)
            {
                if (type == STATE)
                {
                    if (FlxG.state.members.indexOf(getTag(tag)) != -1)
                        FlxG.state.remove(getTag(tag), splice);
                    else
                        errorPrint('Object ' + tag + ' Has Not Been Added Yet');
                } else {
                    if (FlxG.state.subState.members.indexOf(getTag(tag)) != -1)
                        FlxG.state.subState.remove(getTag(tag), splice);
                    else
                        errorPrint('Object ' + tag + ' Has Not Been Added Yet');
                }
            }
        );

        set('destroy', function(tag:String)
            {
                if (tagIs(tag, IFlxDestroyable))
                    getTag(tag).destroy();
            }
        );

        set('insert', function(position:Int, tag:String)
            {
                if (type == STATE)
                {
                    if (tagIs(tag, FlxBasic))
                        FlxG.state.insert(position, getTag(tag));
                } else {
                    if (tagIs(tag, FlxBasic))
                        FlxG.state.subState.insert(position, getTag(tag));
                }
            }
        );

        set('debugPrint', CoolUtil.debugPrint);

        set('debugTrace', CoolUtil.debugTrace);

        set('setObjectCameras', function(tag:String, cameras:Array<String>)
            {
                var theCameras:Array<FlxCamera> = [];

                for (cam in cameras)
                    theCameras.push(LuaCamera.cameraFromString(lua, cam));

                if (tagIs(tag, FlxObject))
                {
                    var object:FlxObject = cast(getTag(tag), FlxObject);

                    object.cameras = theCameras;
                }
            }
        );

        set('setVariable', set);

        set('setTag', setTag);

        set('switchState', function(fullClassPath:String, params:Array<Dynamic>)
		{
			CoolUtil.switchState(Type.createInstance(Type.resolveClass(fullClassPath), params));
		});

        set('switchToCustomState', function(name:String)
		{
			CoolUtil.switchState(() -> new CustomState(name));
		});

        if (type == STATE)
        {
            set('openSubState', function(fullClassPath:String, params:Array<Dynamic>)
            {
                CoolUtil.openSubState(Type.createInstance(Type.resolveClass(fullClassPath), params));
            });

            set('openCustomSubState', function(name:String)
            {
                CoolUtil.openSubState(new CustomSubState(name));
            });
        }

        if (type == SUBSTATE)
        {
            set('close', FlxG.state.subState.close);
        }
    }
}