package funk.gui.js.core.display.commands;

import funk.gui.js.core.display.IGraphicsCommand;

class GraphicsEndFill implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public function new(){
	}

	private function get_type() : GraphicsCommandType {
		return END_FILL;
	}
}