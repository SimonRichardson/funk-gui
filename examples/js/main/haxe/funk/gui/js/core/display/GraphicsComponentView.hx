package funk.gui.js.core.display;

import funk.gui.core.ComponentView;

class GraphicsComponentView extends ComponentView {

	public var graphics(getGraphics, never) : Graphics;

	private var _graphics : Graphics;

	public function new() {
		super();

		_graphics = new Graphics();
	}

	override private function moveTo(x : Float, y : Float) : Void {
		super.moveTo(x, y);

		_graphics.invalidate();
	}

	private function getGraphics() : Graphics {
		return _graphics;
	}
}