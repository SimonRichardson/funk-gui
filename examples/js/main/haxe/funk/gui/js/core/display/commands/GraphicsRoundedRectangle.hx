package funk.gui.js.core.display.commands;

import funk.gui.js.core.display.IGraphicsCommand;

class GraphicsRoundedRectangle implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var x : Float;

	public var y : Float;

	public var width : Float;

	public var height : Float;

	public var radius : Float;

	public function new(x : Float, y : Float, width : Float, height : Float, radius : Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.radius = radius;
	}
	
	private function get_type() : GraphicsCommandType {
		return ROUNDED_RECT(x, y, width, height, ALL(radius));
	}
}