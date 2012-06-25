package funk.gui.js.canvas.display.commands;

import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsMoveTo implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var x : Float;

	public var y : Float;

	public function new(x : Float, y : Float) {
		this.x = x;
		this.y = y;
	}

	private function get_type() : GraphicsCommandType {
		return MOVE_TO(x, y);
	}
}