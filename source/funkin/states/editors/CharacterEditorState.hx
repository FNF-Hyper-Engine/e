package funkin.states.editors;

//import haxe.ui.containers.VBox;

class CharacterEditorState extends MusicBeatState
{
	public var chr:String;

	public var camFollow:FlxObject;

	public var char:Character;

    public var charUI:CharEditorGui;

	var camHUD:FlxCamera;

	public function new(chr:String)
	{
		super();
		this.chr = chr;
	}

	override function create()
	{
		super.create();

	
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.add(camHUD, false);

		StageManager.init('bopeebo', FlxG.camera);
		add(StageManager.stageBack);

		char = new Character(chr);
		add(char);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);
		FlxG.camera.zoom = 0.9;

		FlxG.camera.follow(camFollow, LOCKON, 0.04);

        charUI = new CharEditorGui();
        charUI.scrollFactor.set(0,0);
		charUI.cameras = [camHUD];
        add(charUI);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

tbuild(haxe.ui.ComponentBuilder.build("assets/shared/ui/chart-editor/main-view.xml"))
class CharEditorGui extends flixel.FlxSprite
{
	public function new()
	{
		super(3,3);
	}
}
