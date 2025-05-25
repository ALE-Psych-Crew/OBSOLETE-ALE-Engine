package core.structures;

typedef PsychSection = {
	var sectionNotes:Array<Dynamic>;
	var sectionBeats:Float;
	var mustHitSection:Bool;
	var gfSection:Bool;
	var bpm:Null<Float>;
	var changeBPM:Null<Bool>;
	var altAnim:Bool;
}