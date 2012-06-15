package funk.gui.js.core.display;

import funk.gui.core.ComponentView;

class GraphicsComponentView extends ComponentView {

	public var graphics(getGraphics, never) : Graphics;

	private var _graphics : Graphics;

	public function new(id : Int) {
		super();

		_graphics = new Graphics();
		_graphics.id = id;
	}

	override private function moveTo(x : Float, y : Float) : Void {
		super.moveTo(x, y);

		_graphics.invalidate();
	}

	private function getGraphics() : Graphics {
		return _graphics;
	}
}