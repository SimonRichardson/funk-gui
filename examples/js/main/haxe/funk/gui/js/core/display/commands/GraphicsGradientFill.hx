package funk.gui.js.core.display.commands;

import funk.gui.js.core.display.IGraphicsCommand;

class GraphicsGradientFill implements IGraphicsCommand {

	public var type(get_type, never) : GraphicsCommandType;

	public var colors : Array<Int>;

	public var alphas : Array<Float>;

	public var ratios : Array<Float>;

	public function new(colors : Array<Int>, alphas : Array<Float>, ratios : Array<Float>) {
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
	}

	private function get_type() : GraphicsCommandType {
		return BEGIN_FILL(GRADIENT(colors, alphas, ratios));
	}
}