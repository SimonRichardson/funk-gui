package funk.gui.js.core.display.commands;

import funk.gui.js.core.display.IGraphicsCommand;

class GraphicsTranslate implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var x : Float;

	public var y : Float;

	public function new(x : Float, y : Float) {
		this.x = x;
		this.y = y;
	}

	private function get_type() : GraphicsCommandType {
		return TRANSLATE(x, y);
	}
}