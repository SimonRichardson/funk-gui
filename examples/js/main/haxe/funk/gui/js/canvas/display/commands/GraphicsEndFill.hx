package funk.gui.js.canvas.display.commands;

import funk.gui.js.canvas.display.IGraphicsCommand;

class GraphicsEndFill implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public function new(){
	}

	private function get_type() : GraphicsCommandType {
		return END_FILL;
	}
}