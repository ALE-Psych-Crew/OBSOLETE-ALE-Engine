package cpp;

import winapi.WindowsCPP;
import winapi.WindowsAPI as WinAPI;
import winapi.WindowsAPI.MessageBoxIcon;
import winapi.WindowsTerminalCPP;

class WindowsAPI
{
	public static function obtainRAM():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsCPP.obtainRAM();
	}

	public static function screenCapture(path:String)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.windowsScreenShot(path);
	}

	public static function showMessageBox(caption:String, message:String, icon:MessageBoxIcon = WARNING)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.showMessageBox(caption, message, icon);
	}

	public static function setWindowVisible(mode:Bool)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.setWindowVisible(mode);
	}

	public static function setWindowOppacity(a:Float)
	{
		lime.app.Application.current.window.opacity = a;
	}

	public static function getWindowOppacity():Float
	{
		return lime.app.Application.current.window.opacity;
	}

	public static function setWindowBorderColor(r:Int, g:Int, b:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.setWindowBorderColor(r, g, b);
	}

	public static function hideTaskbar(hide:Bool)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.hideTaskbar(hide);
	}

	public static function setWallpaper(path:String)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.setWallpaper(path);
	}

	public static function hideDesktopIcons(hide:Bool)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.hideDesktopIcons(hide);
	}

	public static function moveDesktopWindowsInX(x:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.moveDesktopWindowsInX(x);
	}

	public static function moveDesktopWindowsInY(y:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.moveDesktopWindowsInY(y);
	}

	public static function moveDesktopWindowsInXY(x:Int, y:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP.moveDesktopWindowsInXY(x, y);
	}

	public static function getDesktopWindowsXPos():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsCPP.returnDesktopWindowsX();
	}

	public static function getDesktopWindowsYPos():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsCPP.returnDesktopWindowsY();
	}

	public static function setTaskBarAlpha(alpha:Float)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsCPP._setTaskBarAlpha(alpha);
	}

	public static function getCursorPositionX()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsCPP.getCursorPositionX();
	}

	public static function getCursorPositionY()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsCPP.getCursorPositionY();
	}

	public static function reDefineMainWindowTitle(windowTitle:String)
	{
		WindowsCPP.reDefineMainWindowTitle(windowTitle);
	}

	public static function clearTerminal()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.clearTerminal();
	}

	public static function showConsole()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.allocConsole();
	}

	public static function hideMainWindow()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.hideMainWindow();
	}

	public static function setConsoleTitle(title:String)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.setConsoleTitle(title);
	}

	public static function setConsoleWindowIcon(path:String)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.setConsoleWindowIcon(path);
	}

	public static function centerConsoleWindow()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.centerConsoleWindow();
	}

	public static function disableResizeConsoleWindow()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.disableResizeConsoleWindow();
	}

	public static function disableCloseConsoleWindow()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.disableCloseConsoleWindow();
	}

	public static function maximizeConsoleWindow()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.maximizeConsoleWindow();
	}

	public static function getConsoleWindowWidth():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsTerminalCPP.returnConsoleWindowWidth();
	}

	public static function getConsoleWindowHeight():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsTerminalCPP.returnConsoleWindowHeight();
	}

	public static function setConsoleCursorPosition(x:Int, y:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.setConsoleCursorPosition(x, y);
	}

	public static function getConsoleCursorPositionInX():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsTerminalCPP.getConsoleCursorPositionInX();
	}

	public static function getConsoleCursorPositionInY():Int
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		return WindowsTerminalCPP.getConsoleCursorPositionInY();
	}

	public static function setConsoleWindowPositionX(posX:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.setConsoleWindowPositionX(posX);
	}

	public static function setConsoleWindowPositionY(posY:Int)
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.setConsoleWindowPositionY(posY);
	}

	public static function hideConsoleWindow()
	{
		reDefineMainWindowTitle(lime.app.Application.current.window.title);
		
		WindowsTerminalCPP.hideConsoleWindow();
	}

	public static function sendNotification(title:String, desc:String)
	{
		WinAPI.sendWindowsNotification(title, desc);
	}
}