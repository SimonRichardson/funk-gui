package funk.gui.js.core.display;

import funk.gui.core.ComponentView;
import funk.option.Any;

using funk.option.Any;

class GraphicsComponentView extends ComponentView {

	public var graphics(getGraphics, never) : Graphics;

	private var _graphics : Graphics;

	public function new(?graphics : Graphics = null) {
		super();

		if(graphics.isDefined()){
			_graphics = graphics;	
		} else {
			_graphics = new Graphics();
		}
	}

	override private function moveTo(x : Float, y : Float) : Void {
		super.moveTo(x, y);

		_graphics.invalidate();
	}

	private function getGraphics() : Graphics {
		return _graphics;
	}
}