package funk.gui.js.canvas.display.commands;

import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsBeginFill implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var color : Int;

	public var alpha : Float;

	public function new(color : Int, ?alpha : Float = 1.0) {
		this.color = color;
		this.alpha = alpha;
	}

	private function get_type() : GraphicsCommandType {
		return BEGIN_FILL(SOLID(color, alpha));
	}
}