package funk.gui.js.canvas.display.commands;

import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsCircle implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var x : Float;

	public var y : Float;

	public var radius : Float;

	public function new(x : Float, y : Float, radius : Float) {
		this.x = x;
		this.y = y;
		this.radius = radius;
	}
	
	private function get_type() : GraphicsCommandType {
		return CIRCLE(x, y, radius);
	}
}