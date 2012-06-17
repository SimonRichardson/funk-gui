package funk.gui.js.core.display;

import funk.gui.core.geom.Rectangle;

enum GraphicsCommandType {
	BEGIN_FILL(color : Int, alpha : Float);
	CIRCLE(x : Float, y : Float, radius : Float);
	CLEAR(bounds : Rectangle);
	END_FILL;
	MOVE_TO(x : Float, y : Float);
	LINE_TO(x : Float, y : Float);
	RECT(x : Float, y : Float, width : Float, height : Float);
	RESTORE;
	ROUNDED_RECT(x : Float, y : Float, width : Float, height : Float, radius : RoundedRectRadiusType);
	SAVE;
	TRANSLATE(x : Float, y : Float);
}

enum RoundedRectRadiusType {
	ALL(radius : Float);
	EACH(topLeft : Float, topRight : Float, bottomLeft : Float, bottomRight : Float);
}

interface IGraphicsCommand {

	var type(dynamic, never) : GraphicsCommandType;
}