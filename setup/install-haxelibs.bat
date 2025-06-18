@echo off
cd ..
@echo on
echo Installing dependencies

@if not exist ".haxelib\" mkdir .haxelib

haxelib git hxcpp https://github.com/AlejoGDOfficial/MobilePorting-hxcpp --skip-dependencies
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 633fcc051399afed6781dd60cbf30ed8c3fe2c5a --skip-dependencies

haxelib install away3d 5.0.9
haxelib install openfl 9.4.1
haxelib install tjson 1.4.0
haxelib install sl-windows-api 1.1.0
haxelib install lime 8.2.2
haxelib git flixel 6.1.0
haxelib install flixel-addons 3.3.2
haxelib install extension-androidtools 2.1.1 --skip-dependencies
haxelib install hxdiscord_rpc 1.3.0 --skip-dependencies
haxelib git ale-ui https://github.com/ALE-Engine-Crew/ALE-UI --skip-dependencies