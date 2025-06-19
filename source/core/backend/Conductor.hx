package core.backend;

class Conductor
{
    public static var bpm:Float = 100;

    public static var beatsPerSection:Int = 4;
    public static var stepsPerBeat:Int = 4;

    public static var crochet(get, never):Float;
    static function get_crochet()
        return 60 / bpm * 1000;

    public static var stepCrochet(get, never):Float;
    static function get_stepCrochet():Float
        return crochet / stepsPerBeat;

    public static var sectionCrochet(get, never):Float;
    static function get_sectionCrochet():Float
        return crochet * beatsPerSection;

    public static var songLength(get, never):Float;
    private static function get_songLength():Float
        return FlxG.sound.music == null ? 0 : FlxG.sound.music.length;

    public static var songPosition(get, never):Float;
    private static function get_songPosition():Float
        return FlxG.sound.music == null ? 0 : FlxG.sound.music.time;

    public static var curStep(get, never):Int;
    private static function get_curStep():Int
        return Math.floor(songPosition / 1000 * bpm / 15);

    public static var curBeat(get, never):Int;
    private static function get_curBeat():Int
        return Math.floor(curStep / stepsPerBeat);

    public static var curSection(get, never):Int;
    private static function get_curSection():Int
        return Math.floor(curBeat / beatsPerSection);
}