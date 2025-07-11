package funkin.debug;

import openfl.text.TextFormat;
import openfl.display.Sprite;
import openfl.text.TextField;

import flixel.util.FlxStringUtil;

import core.backend.Mods;

#if cpp
import cpp.vm.Gc;
#end

class FPSField extends DebugField
{
    var gameData:String = '';

    public function new()
    {
        gameData = (Mods.folder.trim() != '' && Mods.folder.trim() != null ? Mods.folder : 'ALE Engine ' + CoolVars.engineVersion) + (CoolVars.data.developerMode ? ' - Developer Mode' : '');

        super('FPS: 0', 26, 'Memory: [N/A]\n' + gameData, 16);

        text.alpha = 0.75;
    }

    var fps:Float = 0;
    
    var memory:Float = 0;
    var memoryPeak:Float = 0;

    override function __enterFrame(time:#if linux Float #else Int #end)
    {
        super.__enterFrame(time);

        fps = CoolUtil.fpsLerp(fps, FlxG.elapsed == 0 ? 0 : (1 / FlxG.elapsed), 0.25);
    }

    override function updateField(elapsed:Float)
    {
        title.text = 'FPS: ' + Std.string(Math.floor(fps));
        
        #if cpp
        memory = Gc.memInfo64(Gc.MEM_INFO_USAGE);

        if (memoryPeak < memory)
            memoryPeak = memory;

        text.text = 'Memory: ' + FlxStringUtil.formatBytes(memory) + ' / ' + FlxStringUtil.formatBytes(memoryPeak) + '\n' + gameData;
        #end
    }
}