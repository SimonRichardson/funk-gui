package funk.gui.js.canvas.display.commands;

import funk.gui.core.geom.Point;
import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsCreateText implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var text : String;

	public var font : String;

	public var point : Point;

	public function new(text : String, font : String, point : Point) {
		this.text = text;
		this.font = font;
		this.point = point;
	}

	private function get_type() : GraphicsCommandType {
		return CREATE_TEXT(text, font, point);
	}
}