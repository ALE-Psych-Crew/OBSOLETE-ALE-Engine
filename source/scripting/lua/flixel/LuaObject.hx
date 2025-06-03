package scripting.lua.flixel;

import flixel.FlxObject;

import scripting.lua.flixel.LuaCamera;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxAxes;

class LuaObject extends LuaPresetBase
{
    public function new(lua:LuaScript)
    {
        super(lua);

        set('destroy', function(tag:String)
            {
                if (tagIs(tag, IFlxDestroyable))
                    getTag(tag).destroy();
            }
        );

        set('screenCenter', function(tag:String, axes:String)
            {
                if (tagIs(tag, FlxObject))
                    getTag(tag).screenCenter(
                        switch (axes.toLowerCase())
                        {
                            case 'x':
                                FlxAxes.X;
                            case 'y':
                                FlxAxes.Y;
                            default:
                                FlxAxes.XY;
                        }
                    );
            }
        );

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

        set('getObjectOrder', function(tag:String)
            {
                if (tagIs(tag, FlxObject))
                {
                    if (type == STATE)
                        ScriptState.instance.members.indexOf(getTag(tag));
                    else
                        ScriptSubState.instance.members.indexOf(getTag(tag));
                }

                return null;
            }
        );

        set('setObjectOrder', function(tag:String, index:Int)
            {
                if (tagIs(tag, FlxObject))
                {
                    if (type == STATE)
                    {
                        ScriptState.instance.remove(getTag(tag));
                        ScriptState.instance.insert(index, getTag(tag));
                    } else {
                        ScriptSubState.instance.remove(getTag(tag));
                        ScriptSubState.instance.insert(index, getTag(tag));
                    }
                }
            }
        );
    }
}