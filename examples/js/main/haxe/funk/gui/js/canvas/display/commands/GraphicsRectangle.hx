package funk.gui.js.canvas.display.commands;

import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsRectangle implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var x : Float;

	public var y : Float;

	public var width : Float;

	public var height : Float;

	public function new(x : Float, y : Float, width : Float, height : Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	private function get_type() : GraphicsCommandType {
		return RECT(x, y, width, height);
	}
}