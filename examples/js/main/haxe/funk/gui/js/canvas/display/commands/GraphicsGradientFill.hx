package funk.gui.js.canvas.display.commands;

import funk.gui.js.canvas.display.IGraphicsCommand;

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