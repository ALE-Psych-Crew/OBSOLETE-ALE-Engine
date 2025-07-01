@echo off
cd ..
@echo on
echo Installing dependencies

@if not exist ".haxelib\" mkdir .haxelib

haxelib git hxcpp https://github.com/AlejoGDOfficial/MobilePorting-hxcpp --skip-dependencies
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 633fcc051399afed6781dd60cbf30ed8c3fe2c5a --skip-dependencies
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666 --skip-dependencies
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis 1966f8fbbbc509ed90d4b520f3c49c084fc92fd6
haxelib git ale-ui https://github.com/ALE-Engine-Crew/ALE-UI --skip-dependencies

haxelib install nape-haxe4 2.0.22
haxelib install away3d 5.0.9
haxelib install openfl 9.4.1
haxelib install tink_core 1.26.0
haxelib install tjson 1.4.0
haxelib install sl-windows-api 1.1.0
haxelib install lime 8.2.2
haxelib install flixel 6.1.0
haxelib install flixel-addons 3.3.2
haxelib install extension-androidtools 2.2.1 --skip-dependencies
haxelib install hxdiscord_rpc 1.3.0 --skip-dependencies
haxelib install hxvlc 2.2.2 --skip-dependencies
haxelib install rulescript 0.2.0