package funk.gui.js.core.display;

enum GraphicsCommandType {
	BEGIN_FILL(color : Int, alpha : Float);
	END_FILL;
	MOVE_TO(x : Float, y : Float);
	LINE_TO(x : Float, y : Float);
	RECT(x : Float, y : Float, width : Float, height : Float);
	RESTORE;
	SAVE;
	TRANSLATE(x : Float, y : Float);
}

interface IGraphicsCommand {

	var type(dynamic, never) : GraphicsCommandType;
}