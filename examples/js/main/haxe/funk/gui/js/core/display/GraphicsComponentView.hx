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

	private function getGraphics() : Graphics {
		return _graphics;
	}
}