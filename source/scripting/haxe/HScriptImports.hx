package scripting.haxe;

#if COMPILE_ALL_CLASSES

// ---------- Flixel ---------- //

import flixel.util.FlxArrayUtil;
import flixel.util.FlxAxes;
import flixel.util.FlxBitmapDataPool;
import flixel.util.FlxBitmapDataUtil;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxColorTransformUtil;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDirection;
import flixel.util.FlxDirectionFlags;
import flixel.util.FlxGradient;
import flixel.util.FlxHorizontalAlign;
import flixel.util.FlxPool;
import flixel.util.FlxSave;
import flixel.util.FlxSignal;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxVerticalAlign;

import flixel.ui.FlxAnalog;
import flixel.ui.FlxBar;
import flixel.ui.FlxBitmapTextButton;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.ui.FlxVirtualPad;
import flixel.ui.FlxVirtualStick;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTile;
import flixel.tile.FlxTileblock;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTilemapBuffer;

import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.text.FlxInputText;
import flixel.text.FlxInputTextManager;
import flixel.text.FlxText;

import flixel.system.FlxAssets;
import flixel.system.FlxBasePreloader;
import flixel.system.FlxBGSprite;
import flixel.system.FlxLinkedList;
import flixel.system.FlxPreloader;
import flixel.system.FlxQuadTree;
import flixel.system.FlxSplash;
import flixel.system.FlxVersion;

import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;

import flixel.path.FlxBasePath;
import flixel.path.FlxPath;
import flixel.path.FlxPathfinder;

import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.math.FlxVelocity;

import flixel.input.FlxAccelerometer;
import flixel.input.FlxBaseKeyList;
import flixel.input.FlxInput;
import flixel.input.FlxKeyManager;
import flixel.input.FlxPointer;
import flixel.input.FlxSwipe;
import flixel.input.IFlxInput;
import flixel.input.IFlxInputManager;

import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteContainer;
import flixel.group.FlxSpriteGroup;

import flixel.graphics.FlxAsepriteUtil;
import flixel.graphics.FlxGraphic;

import flixel.effects.FlxFlicker;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

import flixel.animation.FlxAnimation;
import flixel.animation.FlxAnimationController;
import flixel.animation.FlxBaseAnimation;
import flixel.animation.FlxPrerotatedAnimation;

// ---------- Flixel Addons ---------- //

import flixel.addons.api.FlxGameJolt;
import flixel.addons.api.FlxKongregate;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxExtendedMouseSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxMouseSpring;
import flixel.addons.display.FlxNestedSprite;
import flixel.addons.display.FlxPieDial;
import flixel.addons.display.FlxRadialGauge;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.display.FlxShaderMaskCamera;
import flixel.addons.display.FlxSliceSprite;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.addons.display.FlxStarField;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.display.FlxZoomCamera;

import flixel.addons.effects.FlxClothSprite;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;

import flixel.addons.ui.FlxButtonPlus;
import flixel.addons.ui.FlxClickArea;
import flixel.addons.ui.FlxSlider;

import flixel.addons.plugin.FlxMouseControl;
import flixel.addons.plugin.FlxScrollingText;

import flixel.addons.text.FlxTextField;
import flixel.addons.text.FlxTypeText;

import flixel.addons.tile.FlxCaveGenerator;
import flixel.addons.tile.FlxRayCastTilemap;
import flixel.addons.tile.FlxTileAnimation;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.transition.Transition;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionEffect;
import flixel.addons.transition.TransitionFade;
import flixel.addons.transition.TransitionTiles;

import flixel.addons.util.FlxAsyncLoop;
import flixel.addons.util.FlxFSM;
import flixel.addons.util.FlxScene;
import flixel.addons.util.FlxSimplex;
import flixel.addons.util.PNGEncoder;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.editors.ogmo.FlxOgmoLoader;

// ---------- Haxe ---------- //

import DateTools;
import EReg;
import Lambda;
import StringBuf;

import haxe.crypto.Adler32;
import haxe.crypto.Base64;
import haxe.crypto.BaseCode;
import haxe.crypto.Crc32;
import haxe.crypto.Hmac;
import haxe.crypto.Md5;
import haxe.crypto.Sha1;
import haxe.crypto.Sha224;
import haxe.crypto.Sha256;

import haxe.display.Diagnostic;
import haxe.display.Display;
import haxe.display.FsPath;
import haxe.display.JsonModuleTypes;
import haxe.display.Position;
import haxe.display.Protocol;
import haxe.display.Server;

import haxe.exceptions.ArgumentException;
import haxe.exceptions.NotImplementedException;
import haxe.exceptions.PosException;

import haxe.extern.AsVar;
import haxe.extern.EitherType;
import haxe.extern.Rest;

// ---------- Sys ---------- //

import sys.FileStat;
import sys.FileSystem;
import sys.Http;

import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.io.FileSeek;
import sys.io.Process;

// ---------- OpenFL ---------- //

import openfl.Lib;

import openfl.net.DatagramSocket;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.FileReferenceList;
import openfl.net.IDynamicPropertyOutput;
import openfl.net.IDynamicPropertyWriter;
import openfl.net.IPVersion;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import openfl.net.ObjectEncoding;
import openfl.net.Responder;
import openfl.net.SecureSocket;
import openfl.net.ServerSocket;
import openfl.net.SharedObject;
import openfl.net.SharedObjectFlushStatus;
import openfl.net.Socket;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestDefaults;
import openfl.net.URLRequestHeader;
import openfl.net.URLRequestMethod;
import openfl.net.URLStream;
import openfl.net.URLVariables;
import openfl.net.XMLSocket;

// ---------- ALE UI ---------- //

import ale.ui.ALEButton;
import ale.ui.ALETaskBar;
import ale.ui.ALEUIUtils;
import ale.ui.ALEWindow;

// ---------- Funkin' ---------- //

import funkin.visuals.objects.AttachedSprite;
import funkin.visuals.objects.AttachedText;
import funkin.visuals.objects.Alphabet;
import funkin.visuals.objects.TypedAlphabet;
import funkin.visuals.objects.AttachedAlphabet;
import funkin.visuals.objects.Visualizer;
import funkin.visuals.objects.VideoSprite;

import funkin.visuals.editors.chart.ChartNote;

#end

import funkin.states.OptionsState;

class HScriptImports {}