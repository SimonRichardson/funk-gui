package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.IGraphicsCommand;

import js.w3c.html5.Canvas2DContext;

using funk.collections.immutable.Nil;

class Painter {

	public var size(getSize, never) : Int;

	private var _context : CanvasRenderingContext2D;

	private var _list : IList<Graphics>;

	private var _rendering : Bool;

	public function new(context : CanvasRenderingContext2D) {		
		_context = context;

		_rendering = false;
		_list = nil.list();
	}

	public function add(graphics : Graphics, rect : Rectangle) : Void {
		if(rect.width <= 0 || rect.height <= 0) return;

		_list = _list.append(graphics);
	}

	public function removeAll() : Void {
		_list = nil.list();
	}

	public function render() : Void {
		if(_rendering) return;
		else {
			_rendering = true;

			var p : IList<Graphics> = _list;
			// TODO : Work out if we're clearing & if we are then work out if we're 
			// overdrawing. If overdrawing is happening then work out the rendering order
			// so we invalidate the overdraws.
			while(p.nonEmpty) {
				var graphics : Graphics = p.head;

				// We've not changed, continue.
				if(!graphics.isDirty) {
					p = p.tail;

					continue;
				}

				var max : Rectangle = graphics.bounds.clone();

				// Render the commands.
				var commands : IList<IGraphicsCommand> = graphics.commands;
				for(c in commands) {
					var command : IGraphicsCommand = c;

					switch(command.type) {
						case BEGIN_FILL(color, alpha): 
							_context.fillStyle = StringTools.hex(color, 6);
						case CLEAR(bounds):

							if(bounds.x < max.x) max.x = bounds.x;
							if(bounds.y < max.y) max.y = bounds.y;
							if(bounds.width > max.width) max.width = bounds.width;
							if(bounds.height > max.height) max.height = bounds.height;

							_context.clearRect(bounds.x, bounds.y, bounds.width, bounds.height);
						case END_FILL: 
							_context.fill();
						case MOVE_TO(x, y): 
							_context.moveTo(x, y);
						case LINE_TO(x, y): 
							_context.lineTo(x, y);
						case SAVE:
							_context.save();
						case RECT(x, y, width, height): 
							_context.fillRect(x, y, width, height);
						case RESTORE:
							_context.restore();
						case TRANSLATE(x, y):
							_context.translate(x, y);
					}
				}

				// Find out if we're overlapping something here (if so mark as invalidated)
				// TODO : Pre-compute the dirty regions.
				markInsersections(max, p.tail);

				graphics.validated();

				p = p.tail;
			}

			_rendering = false;
		}
	}

	private function markInsersections(bounds : Rectangle, list : IList<Graphics>) : Void {
		var p : IList<Graphics> = list;
		while(p.nonEmpty) {
			var graphics : Graphics = p.head;

			if(bounds.intersects(graphics.bounds)) {
				graphics.invalidate();
			}

			p = p.tail;
		}
	}

	private function getSize() : Int {
		return _list.size;
	}
}