package scripting.lua.flixel;

import flixel.FlxBasic;

@:access(core.backend.ScriptState)
@:access(core.backend.ScriptSubState)
class LuaState extends LuaPresetBase
{
    override public function new(lua:LuaScript)
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

        if (type == STATE)
        {
            set('openSubState', function(fullClassPath:String, params:Array<Dynamic>)
            {
                CoolUtil.openSubState(Type.createInstance(Type.resolveClass(fullClassPath), params));
            });

            set('openCustomSubState', function(name:String, ?params:Array<Dynamic>)
            {
                CoolUtil.openSubState(new CustomSubState(name, params));
            });
        }

        if (type == SUBSTATE)
        {
            set('close', FlxG.state.subState.close);
        }
    }
}