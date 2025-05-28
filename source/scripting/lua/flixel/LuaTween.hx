package scripting.lua.flixel;

import scripting.lua.haxe.LuaReflect;

import flixel.tweens.FlxTween.FlxTweenType;

class LuaTween extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('tween', function(tag:String, vars:String, valueTypes:Dynamic, duration:Float, ?options:Dynamic)
            {
                var types = {};

                for (field in Reflect.fields(valueTypes))
                    Reflect.setField(types, field, Reflect.field(valueTypes, field));

				var opts = {};

				for (field in Reflect.fields(options))
				{
					switch (field)
					{
						case 'type':
							Reflect.setField(opts, 'type', tweenTypeByString(Reflect.field(options, field)));
						case 'startDelay':
							Reflect.setField(opts, 'startDelay', Reflect.field(options, field));
						case 'loopDelay':
							Reflect.setField(opts, 'loopDelay', Reflect.field(options, field));
						case 'ease':
							Reflect.setField(opts, 'ease', easeByString(Reflect.field(options, field)));
					}
				}

                return tweenFunction(tag, vars, types, duration, opts);
            }
        );

        set('cancelTween', cancelTween);

		set('cancelTweensOf', function(tag:String)
			{
				FlxTween.cancelTweensOf(getTag(tag));
			}
		);
    }

    function tweenFunction(tag:String, vars:String, tweenValue:Dynamic, duration:Float, options:Dynamic)
    {
		var ogTag:String = tag;

		var theOptions = {
			onStart: function(twn:FlxTween)
			{
				if (type == STATE)
				{
					if (ScriptState.instance != null)
						ScriptState.instance.callOnLuaScripts('onTweenStart', [ogTag]);
				} else {
					if (ScriptSubState.instance != null)
						ScriptSubState.instance.callOnLuaScripts('onTweenStart', [ogTag]);
				}
			},
			onComplete: function(twn:FlxTween)
			{
				variables.remove(tag);

				if (type == STATE)
				{
					if (ScriptState.instance != null)
						ScriptState.instance.callOnLuaScripts('onTweenComplete', [ogTag]);
				} else {
					if (ScriptSubState.instance != null)
						ScriptSubState.instance.callOnLuaScripts('onTweenComplete', [ogTag]);
				}
			},
			onUpdate: function(twn:FlxTween)
			{
				if (type == STATE)
				{
					if (ScriptState.instance != null)
						ScriptState.instance.callOnLuaScripts('onTweenUpdate', [ogTag]);
				} else {
					if (ScriptSubState.instance != null)
						ScriptSubState.instance.callOnLuaScripts('onTweenUpdate', [ogTag]);
				}
			}
		};

		for (field in Reflect.fields(options))
			Reflect.setField(theOptions, field, Reflect.field(options, field));

        var target:Dynamic = tweenPrepare(tag, vars);

        if (target != null)
        {
            if (tag != null)
            {
                tag = LuaReflect.formatVariable('tween_' + tag);

                setTag(tag, FlxTween.tween(target, tweenValue, duration, theOptions));
            } else {
                FlxTween.tween(target, tweenValue, duration, theOptions);
            }

            return tag;
        } else {
            errorPrint('Objects doesn\'t Exists: ' + vars);
        }

        return null;
    }

    function tweenPrepare(tag:String, vars:String)
    {
        if (tag != null)
            cancelTween(tag);

        return LuaReflect.parseVariable(lua, vars);
    }

    function cancelTween(tag:String)
    {
        if (!tag.startsWith('tween_'))
            tag = 'tween_' + LuaReflect.formatVariable(tag);

        var tween:FlxTween = variables.get(tag);

        if (tween != null)
        {
            tween.cancel();
            tween.destroy();

            variables.remove(tag);
        }
    }

	public static function easeByString(?ease:String = '')
    {
		return switch(ease.toLowerCase().trim())
        {
			case 'backin':
				FlxEase.backIn;
			case 'backinout':
				FlxEase.backInOut;
			case 'backout':
				FlxEase.backOut;
			case 'bouncein':
				FlxEase.bounceIn;
			case 'bounceinout':
				FlxEase.bounceInOut;
			case 'bounceout':
				FlxEase.bounceOut;
			case 'circin':
				FlxEase.circIn;
			case 'circinout':
				FlxEase.circInOut;
			case 'circout':
				FlxEase.circOut;
			case 'cubein':
				FlxEase.cubeIn;
			case 'cubeinout':
				FlxEase.cubeInOut;
			case 'cubeout':
				FlxEase.cubeOut;
			case 'elasticin':
				FlxEase.elasticIn;
			case 'elasticinout':
				FlxEase.elasticInOut;
			case 'elasticout':
				FlxEase.elasticOut;
			case 'expoin':
				FlxEase.expoIn;
			case 'expoinout':
				FlxEase.expoInOut;
			case 'expoout':
				FlxEase.expoOut;
			case 'quadin':
				FlxEase.quadIn;
			case 'quadinout':
				FlxEase.quadInOut;
			case 'quadout':
				FlxEase.quadOut;
			case 'quartin':
				FlxEase.quartIn;
			case 'quartinout':
				FlxEase.quartInOut;
			case 'quartout':
				FlxEase.quartOut;
			case 'quintin':
				FlxEase.quintIn;
			case 'quintinout':
				FlxEase.quintInOut;
			case 'quintout':
				FlxEase.quintOut;
			case 'sinein':
				FlxEase.sineIn;
			case 'sineinout':
				FlxEase.sineInOut;
			case 'sineout':
				FlxEase.sineOut;
			case 'smoothstepin':
				FlxEase.smoothStepIn;
			case 'smoothstepinout':
				FlxEase.smoothStepInOut;
			case 'smoothstepout':
				FlxEase.smoothStepOut;
			case 'smootherstepin':
				FlxEase.smootherStepIn;
			case 'smootherstepinout':
				FlxEase.smootherStepInOut;
			case 'smootherstepout':
				FlxEase.smootherStepOut;
			default:
				FlxEase.linear;
		}
	}

	public static function tweenTypeByString(?type:String)
	{
		return switch (type.toUpperCase().trim())
		{
			case 'BACKWARD':
				FlxTweenType.BACKWARD;
			case 'LOOPING':
				FlxTweenType.LOOPING;
			case 'ONESHOT':
				FlxTweenType.ONESHOT;
			case 'PERSIST':
				FlxTweenType.PERSIST;
			case 'PINGPONG':
				FlxTweenType.PINGPONG;
			default:
				null;
		}
	}
}