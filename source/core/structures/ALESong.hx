package core.structures;

typedef ALESong =
{
    var events:Array<ALEEventArray>;

    var song:String;
    var needsVoices:Bool;
    
    var bpm:Float;
    var beats:Int;
    var steps:Int;
    
    var characters:Array<Array<String>>;

    var sections:Array<ALESection>;
    
    var speed:Float;

    var stage:String;

    var format:String;
	
	@:optional var disableNoteRGB:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;

	@:optional var metadata:Dynamic;
	@:optional var gameOverScript:String;
	@:optional var pauseScript:String;
}