package funk.gui.js.core.display.commands;

import funk.gui.js.core.display.IGraphicsCommand;

class GraphicsRoundedRectangleComplex implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var x : Float;

	public var y : Float;

	public var width : Float;

	public var height : Float;

	public var topLeft : Float;

	public var topRight : Float;

	public var bottomLeft : Float;

	public var bottomRight : Float;

	public function new(	x : Float, 
							y : Float, 
							width : Float, 
							height : Float, 
							topLeft : Float,
							topRight : Float,
							bottomLeft : Float,
							bottomRight : Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

		this.topLeft = topLeft;
		this.topRight = topRight;
		this.bottomLeft = bottomLeft;
		this.bottomRight = bottomRight;
	}
	
	private function get_type() : GraphicsCommandType {
		return ROUNDED_RECT(x, y, width, height, EACH(topLeft, topRight, bottomLeft, bottomRight));
	}
}