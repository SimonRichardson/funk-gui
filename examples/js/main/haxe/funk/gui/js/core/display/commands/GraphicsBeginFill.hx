package funk.gui.js.core.display.commands;

import funk.gui.js.core.display.IGraphicsCommand;

class GraphicsBeginFill implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var color : Int;

	public var alpha : Float;

	public function new(color : Int, alpha : Float) {
		this.color = color;
		this.alpha = alpha;
	}

	private function get_type() : GraphicsCommandType {
		return BEGIN_FILL(color, alpha);
	}
}