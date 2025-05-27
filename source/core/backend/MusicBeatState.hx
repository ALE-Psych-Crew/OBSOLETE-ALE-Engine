package core.backend;

import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxStringUtil;

#if cpp
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#end

import core.enums.PrintType;

import funkin.visuals.objects.DebugText;

/**
 * It is a FlxState extension that calculates the Beats, Steps and Sections of the game music (FlxG.sound.music)
 */
class MusicBeatState extends FlxState
{
    public var curStep:Int = 0;
    public var curBeat:Int = 0;
    public var curSection:Int = 0;

    public static var instance:MusicBeatState;

    private var debugTexts:FlxTypedGroup<DebugText>;
    
    override public function create()
    {
        instance = this;
        
		debugTexts = new FlxTypedGroup<DebugText>();
		add(debugTexts);

        if (CoolVars.skipTransOut)
        {
            CoolVars.skipTransOut = false;
        } else {
            #if cpp
            CoolUtil.openSubState(new CustomSubState(
                CoolVars.data.transition,
                null,
                [
                    'transIn' => false,
                    'transOut' => true,
                    'finishCallback' => null
                ],
                [
                    'transIn' => false,
                    'transOut' => true,
                    'finishCallback' => null
                ]
            ));
            #end
        }

        super.create();
    }

    public inline function debugPrint(text:Dynamic, ?type:Null<PrintType> = TRACE, ?customType:String = '', ?customColor:FlxColor = FlxColor.GRAY) 
    {
        text = Std.string(text);

        if (debugTexts != null)
        {
            var newText:DebugText = debugTexts.recycle(DebugText);
            newText.text = (type == CUSTOM ? customType : PrintType.typeToString(type)) + ' | ' + text;
            newText.color = (type == CUSTOM ? customColor : PrintType.typeToColor(type));
            newText.disableTime = 6;
            newText.alpha = 1;
            newText.setPosition(10, 8 - newText.height);
            newText.scrollFactor.set();
            
            debugTexts.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    
            debugTexts.forEachAlive(
                function (text:DebugText)
                {
                    text.y += newText.height + 2;
                }
            );
    
            debugTexts.add(newText);
        }

        debugTrace(text, type, customType, customColor);
    }

    public var shouldClearMemory:Bool = true;

    override public function destroy()
    {
        instance = null;

        debugTexts = null;

        if (shouldClearMemory)
            cleanMemory();
        
        super.destroy();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        updateMusic();
    }

    private function updateMusic()
    {
        if (curStep != Conductor.curStep)
        {
            curStep = Conductor.curStep;

            stepHit(curStep);
        }
        
        if (curBeat != Conductor.curBeat)
        {
            curBeat = Conductor.curBeat;

            beatHit(curBeat);
        }
        
        if (curSection != Conductor.curSection)
        {
            curSection = Conductor.curSection;

            sectionHit(curSection);
        }
    }

    public function stepHit(curStep:Int) {}

    public function beatHit(curBeat:Int) {}

    public function sectionHit(curSection:Int) {}

    private function cleanMemory()
    {
        Paths.clearEngineCache();

        #if cpp
        var killZombies:Bool = true;
        
        while (killZombies) {
            var zombie = Gc.getNextZombie();
        
            if (zombie == null) {
                killZombies = false;
            } else {
                var closeMethod = Reflect.field(zombie, "close");
        
                if (closeMethod != null && Reflect.isFunction(closeMethod))
                    closeMethod.call(zombie, []);
            }
        }
        
        Gc.run(true);
        Gc.compact();
        #end
        
        #if hl
        Gc.major();
        #end
        
        FlxG.bitmap.clearUnused();
        FlxG.bitmap.clearCache();
    }
}