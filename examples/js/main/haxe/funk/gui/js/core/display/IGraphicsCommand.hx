package funk.gui.js.core.display;

import funk.gui.core.geom.Rectangle;

enum GraphicsCommandType {
	BEGIN_FILL(color : Int, alpha : Float);
	CLEAR(bounds : Rectangle);
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