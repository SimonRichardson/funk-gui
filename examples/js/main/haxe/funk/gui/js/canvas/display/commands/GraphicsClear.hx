package funk.gui.js.canvas.display.commands;

import funk.gui.core.geom.Rectangle;
import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsClear implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var bounds : Rectangle;

	public function new(bounds : Rectangle) {
		this.bounds = bounds;
	}

	private function get_type() : GraphicsCommandType {
		return CLEAR(bounds);
	}
}