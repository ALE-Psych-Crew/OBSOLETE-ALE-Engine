package scripting.haxe.imports;

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

class FlixelImports {}