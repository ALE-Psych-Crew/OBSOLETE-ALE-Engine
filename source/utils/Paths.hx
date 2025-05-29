package utils;

import core.enums.PathType;

import haxe.ds.StringMap;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;

import core.backend.Mods;

import flash.media.Sound;

/**
 * Serves to assist with file loading
 */
class Paths
{
    public static inline final IMAGE_EXT = 'png';
	public static inline final SOUND_EXT = #if web 'mp3' #else 'ogg' #end;
	public static inline final VIDEO_EXT = 'mp4';

	public static var cachedGraphics:StringMap<FlxGraphic> = new StringMap<FlxGraphic>();
    public static var cachedSounds:StringMap<Sound> = new StringMap<Sound>();

    /**
     * Used to load a PNG image
     * @param file File Name
     * @return FlxGraphic
     */
    public static function image(file:String):FlxGraphic
    {
        var path = 'images/' + file + '.' + IMAGE_EXT;

        var bitmap:BitmapData = null;

        if (cachedGraphics.exists(path))
            return cachedGraphics.get(path);
        else if (fileExists(path))
            bitmap = BitmapData.fromFile(getPath(path));

        if (bitmap != null)
        {
            var returnValue = cacheBitmap(path, bitmap);

            if (returnValue != null)
                return returnValue;
        }

        debugTrace(path, MISSING_FILE);

        return null;
    }
    
	/**
	 * Used to Cache Bitmaps
     * (Taken from Psych Engine)
	 * @param file File Name
	 * @param bitmap Bitmap Data
	 */
	public static function cacheBitmap(file:String, ?bitmap:BitmapData = null):FlxGraphic
	{
		if (bitmap == null)
		{
			if (FileSystem.exists(file))
				bitmap = BitmapData.fromFile(file);
            
			if (bitmap == null)
                return null;
		}

		if (ClientPrefs.data.cacheOnGPU)
		{
			var texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);
			texture.uploadFromBitmapData(bitmap);

			bitmap.image.data = null;
			bitmap.dispose();
			bitmap.disposeImage();
			bitmap = BitmapData.fromTexture(texture);
		}

		var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, file);
		newGraphic.persist = true;
		newGraphic.destroyOnNoUse = false;
        
		cachedGraphics.set(file, newGraphic);

		return newGraphic;
	}

    public static function inst(songRoute:String):Sound
        return returnSound(songRoute + '/song/Inst');

    public static function voices(songRoute:String, ?prefix:String = ''):Sound
        return returnSound(songRoute + '/song/' + prefix + 'Voices');

    public static function music(file:String):Sound
        return returnSound('music/' + file);

    public static function sound(file:String):Sound
        return returnSound('sounds/' + file);

    private static function returnSound(file:String):Sound
    {
        var path = file + '.' + SOUND_EXT;

        var sound:Sound = null;

        if (cachedSounds.exists(path))
            return cachedSounds.get(path);
        else if (fileExists(path))
            sound = Sound.fromFile(getPath(path));

        if (sound != null)
        {
            var returnValue = cacheSound(path, sound);

            if (returnValue != null)
                return returnValue;
        }

        debugTrace(path, MISSING_FILE);

        return null;
    }

    public static function cacheSound(file:String, ?sound:Sound = null):Sound
    {
        if (sound == null)
        {
            if (FileSystem.exists(file))
                sound = Sound.fromFile(file);

            if (sound == null)
                return null;
        }

        cachedSounds.set(file, sound);

        return sound;
    }

    /**
     * Used to load an .XML File
     * @param file File Name
     * @return String
     */
    public static function xml(file:String):String
    {
        var path = 'images/' + file + '.xml';

        if (!fileExists(path))
        {
            debugTrace(path, MISSING_FILE);
            return null;
        }

        return File.getContent(getPath(path));
    }

    public static function imageTxt(file:String):String
    {
        var path = 'images/' + file + '.txt';

        if (!fileExists(path))
        {
            debugTrace(path, MISSING_FILE);
            return null;
        }

        return File.getContent(getPath(path));
    }
    
    public static function imageJson(file:String):String
    {
        var path = 'images/' + file + '.json';

        if (!fileExists(file))
        {
            debugTrace(path, MISSING_FILE);
            return null;
        }

        return File.getContent(getPath(path));
    }

    public static function getAtlas(file:String):FlxAtlasFrames
        return getSparrowAtlas(file) ?? getPackerAtlas(file) ?? getAsepriteAtlas(file) ?? null;

    /**
     * Used to load image animations from XML
     * @param file File Name
     * @return FlxAtlasFrames
     */
    public static function getSparrowAtlas(file:String):FlxAtlasFrames
    {
        var graphic = image(file);
        var xmlContent = xml(file);

        if (graphic == null || xmlContent == null)
            return null;

        return FlxAtlasFrames.fromSparrow(graphic, xmlContent);
    }
    
    public static function getPackerAtlas(file:String):FlxAtlasFrames
    {
        var graphic = image(file);
        var txtContent = imageTxt(file);

        if (graphic == null || txtContent == null)
            return null;

        return FlxAtlasFrames.fromSpriteSheetPacker(graphic, txtContent);
    }

    public static function getAsepriteAtlas(file:String):FlxAtlasFrames
    {
        var graphic = image(file);
        var jsonContent = imageJson(file);

        if (graphic == null || jsonContent == null)
            return null;

        return FlxAtlasFrames.fromTexturePackerJson(graphic, jsonContent);
    }

    /**
     * Used to get the Path of a Font
     * @param file File Name
     * @return String
     */
    public static function font(file:String):String
    {
        var path = 'fonts/' + file;

        if (!fileExists(path))
        {
            debugTrace(path, MISSING_FILE);
            return null;
        }

        return getPath(path);
    }

    /**
     * Defines where the files should be searched
     * @param file File Path
     * @return String
     */
    public static inline function getPath(file:String):String
    {
        #if MODS_ALLOWED
        if (fileExists(file, MODS))
            return modFolder() + '/' + file;
        #end

        if (fileExists(file, ASSETS))
            return 'assets/' + file;

        debugTrace(file, MISSING_FILE);

        return null;
    }

    /**
     * Determines whether or not a file exists
     * @param path File Path
     * @param pathMode ASSETS | MODS | BOTH
     * @return Bool
     */
    public static inline function fileExists(path:String, ?pathMode:PathType = BOTH):Bool
    {
        #if MODS_ALLOWED
        if (FileSystem.exists(modFolder() + '/' + path) && (pathMode == MODS || pathMode == BOTH) && Mods.folder != '' && Mods.folder != null)
            return true;
        #end

        if (FileSystem.exists('assets/' + path) && (pathMode == ASSETS || pathMode == BOTH))
            return true;
        
        return false;
    }

    public static inline function modFolder():String
        return 'mods/' + Mods.folder;
    
    public static function clearEngineCache()
    {
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);

			if (obj != null && !cachedGraphics.exists(key))
			{
				FlxG.bitmap._cache.remove(key);

				obj.destroy();
			}
		}

        for (key in cachedGraphics.keys())
            cachedGraphics.remove(key);

        for (key in cachedSounds.keys())
            cachedSounds.remove(key);
    }
}