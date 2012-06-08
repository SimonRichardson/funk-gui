package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.IGraphicsCommand;

import js.w3c.html5.Canvas2DContext;

using funk.collections.immutable.Nil;

class Painter {

	private var _context : CanvasRenderingContext2D;

	private var _list : IList<IGraphicsCommand>;

	public function new(context : CanvasRenderingContext2D) {		
		_context = context;

		_list = nil.list();
	}

	public function add(graphics : Graphics, rect : Rectangle) : Void {
		if(rect.width <= 0 || rect.height <= 0) return;

		_list = _list.prependAll(graphics.commands);
	}

	public function render() : Void {
		var p = _list;
		for(i in p) {
			var command : IGraphicsCommand = i;
			switch(command.type) {
				case BEGIN_FILL(color, alpha): 
					_context.fillStyle = StringTools.hex(color);
				case END_FILL: 
					_context.fill();
				case MOVE_TO(x, y): 
					_context.moveTo(x, y);
				case LINE_TO(x, y): 
					_context.lineTo(x, y);
				case RECT(x, y, width, height): 
					_context.fillRect(x, y, width, height);
				case TRANSLATE(x, y): 
					_context.translate(x, y);
			}
		}
	}
}