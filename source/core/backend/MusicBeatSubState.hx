package core.backend;

import funkin.visuals.objects.DebugText;

import core.enums.PrintType;

class MusicBeatSubState extends flixel.FlxSubState
{
    public var curStep:Int = 0;
    public var curBeat:Int = 0;
    public var curSection:Int = 0;

    public static var instance:MusicBeatSubState;

    private var debugTexts:FlxTypedGroup<DebugText>;

    override public function create()
    {
        instance = this;
        
		debugTexts = new FlxTypedGroup<DebugText>();
		add(debugTexts);

        super.create();
    }

    public inline function debugPrint(text:Dynamic, ?type:Null<PrintType> = TRACE, ?customType:String = '', ?customColor:FlxColor = FlxColor.GRAY) 
    {
        text = haxe.Log.formatOutput(text, null);

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

    override public function destroy()
    {
        instance = null;

        debugTexts = null;

        super.destroy();
    }

    override public function update(elapsed:Float)
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
}