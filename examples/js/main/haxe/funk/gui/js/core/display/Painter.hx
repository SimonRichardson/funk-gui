package funk.gui.js.core.display;

import funk.gui.core.geom.Rectangle;

class Painter {

	public function new() {		
	}

	public function draw(graphics : Graphics, rect : Rectangle) : Void {
		trace(rect);
		if(rect.width <= 0 || rect.height <= 0) return;
	}
}