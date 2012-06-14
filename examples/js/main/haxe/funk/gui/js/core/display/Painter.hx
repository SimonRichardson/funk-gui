package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.IGraphicsCommand;

import js.w3c.html5.Canvas2DContext;

using funk.collections.immutable.Nil;

class Painter {

	public var bounds(getBounds, never) : Rectangle;

	public var size(getSize, never) : Int;

	private var _context : CanvasRenderingContext2D;

	private var _bounds : Rectangle;

	private var _list : IList<Graphics>;

	private var _highQuality : Bool;

	public function new(context : CanvasRenderingContext2D, highQuality : Bool) {		
		_context = context;
		_highQuality = highQuality;

		_list = nil.list();
		_bounds = new Rectangle();
	}

	public function add(graphics : Graphics, rect : Rectangle) : Void {
		if(rect.width <= 0 || rect.height <= 0) return;

		_list = _list.append(graphics);
	}

	public function removeAll() : Void {
		_list = nil.list();
	}

	public function render() : Void {
		var graphics : Graphics;

		// 1) Invalidate all the drawing list from the known graphics max bounds
		// Note: This is CPU intensive, so should be optimisted - worst case is O(n^2) atm.
		var p : IList<Graphics> = _list;
		while(p.nonEmpty) {
			graphics = p.head;

			// If we're running in high quality we have to oversample everything again!
			if(_highQuality) {
				graphics.invalidate();
			} else if(graphics.isDirty) {
				markInsersections(graphics, _list);
			}

			p = p.tail;
		}

		// 2) Go through the whole drawing list in re-render all the known graphics
		// If in high quality mode we clear the whole screen rect.
		if(_highQuality) {
			_context.clearRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
		}

		p = _list;
		while(p.nonEmpty) {
			graphics = p.head;

			// The graphics hasn't been invalidated so just continue.
			if(graphics.isDirty) {

				var hasFill : Bool = false;
				var hasPathOpen : Bool = false;

				// Render the commands.
				var commands : IList<IGraphicsCommand> = graphics.commands;
				for(c in commands) {
					var command : IGraphicsCommand = c;

					switch(command.type) {
						case BEGIN_FILL(color, alpha): 
							hasFill = true;
							_context.fillStyle = StringTools.hex(color, 6);

						case CIRCLE(x, y, radius):
							if(!hasPathOpen) {
								hasPathOpen = true;
								_context.beginPath();
							}
							_context.arc(x, y, radius, 0, Math.PI * 2, hasFill);

						case CLEAR(bounds):
							hasFill = false;
							hasPathOpen = false;
							if(!_highQuality) {
								_context.clearRect(bounds.x, bounds.y, bounds.width, bounds.height);
							}

						case END_FILL:
							if(hasPathOpen) {
								hasPathOpen = false;
								_context.closePath();
							} 
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

				graphics.validated();
			}

			p = p.tail;
		}
	}

	private function markInsersections(graphics : Graphics, list : IList<Graphics>) : Void {
		var p : IList<Graphics> = list;
		while(p.nonEmpty) {
			var other : Graphics = p.head;

			// Don't test the bounds if they're the same instance.
			if(graphics != other && graphics.bounds.intersects(other.bounds)) {
				other.invalidate();
			}

			p = p.tail;
		}
	}

	private function getBounds() : Rectangle {
		return _bounds;
	}

	private function getSize() : Int {
		return _list.size;
	}
}