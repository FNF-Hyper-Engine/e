package funkin;

import flixel.addons.ui.FlxUIState;

class Init extends FlxState
{
	override function create()
	{
		super.create();
        
        funkin.backend.PlayerSettings.init();

		//funkin.backend.SaveShit.initSave();

		funkin.backend.KeyBinds.keyCheck();
        FlxG.switchState(new TitleState());
	}
}
