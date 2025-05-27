#if !macro
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

import funkin.states.PlayState;
import funkin.states.CustomState;

import funkin.substates.CustomSubState;

import core.backend.MusicBeatState;
import core.backend.MusicBeatSubState;
import core.backend.ScriptState;
import core.backend.ScriptSubState;
import core.backend.Conductor;
import core.backend.DiscordRPC;
import core.backend.Controls;

import core.config.ClientPrefs;

import utils.CoolUtil;
import utils.CoolUtil.debugPrint;
import utils.CoolUtil.debugTrace;
import utils.CoolVars;
import utils.Paths;

import sys.*;
import sys.io.*;

import utils.ALEJson as Json;
import utils.CoolUtil;

using StringTools;
#end