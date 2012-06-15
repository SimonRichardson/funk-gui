package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.IGraphicsCommand;
import funk.option.Any;

import js.w3c.html5.Canvas2DContext;

using funk.collections.immutable.Nil;
using funk.option.Any;

class Painter {

	public var bounds(getBounds, never) : Rectangle;

	public var size(getSize, never) : Int;

	private var _context : CanvasRenderingContext2D;

	private var _bounds : Rectangle;

	private var _list : IList<Graphics>;

	private var _highQuality : Bool;

	private var _debugging : Bool;

	public function new(context : CanvasRenderingContext2D, highQuality : Bool) {		
		_context = context;
		_highQuality = highQuality;

		_list = nil.list();
		_bounds = new Rectangle();

		_debugging = false;

		var document = CommonJS.getHtmlDocument();
		document.onkeydown = function(event : Dynamic) : Void {
			_debugging = !_debugging;
		};
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

		var invalidGraphics : IList<Graphics> = nil.list();
		var clearRects : IList<Rectangle> = nil.list();

		// 1) Invalidate all the drawing list from the known graphics max bounds
		// Note: This is CPU intensive, so should be optimisted - worst case is O(n^2) atm.
		var p : IList<Graphics> = _list;
		while(p.nonEmpty) {
			graphics = p.head;

			// If we're running in high quality we have to oversample everything again!
			if(_highQuality) {
				graphics.invalidate();
			} else if(graphics.isDirty) {
				markInvalidatedGraphics(graphics, _list);
			}

			p = p.tail;
		}

		// 2) Work out the areas that need to be redrawn.
		// If in high quality mode we clear the whole screen rect.
		if(_highQuality) {
			_context.clearRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
		} else {
			// Else work out the areas where we need to clear the screen
			// Work out the rects to clear
			// Note: This is CPU intensive, so should be optimisted - worst case is O(n^2) atm.
			p = _list;
			while(p.nonEmpty) {
				graphics = p.head;
				if(graphics.isDirty) {
					var curBounds : Rectangle = graphics.bounds;
					clearRects = clearRects.prepend(curBounds);

					var preBounds : Rectangle = graphics.previousBounds;
					if(!preBounds.equals(curBounds)) {
						clearRects = clearRects.prepend(preBounds);
					}
					//clearRects = markIntersections(preBounds, clearRects);
				}
				p = p.tail;
			}

			// TODO (Simon) : Work out if the rect angles are many and if so - possibly merge.
			// We could self loop on clearRects with markIntersections so we end up with 
			// a tighter list.

			trace(clearRects.size);

			// Now clear the rects
			var b : IList<Rectangle> = clearRects;
			while(b.nonEmpty) {
				var rect : Rectangle = b.head;
				if(rect.width > 0 && rect.height > 0) {
					_context.clearRect(rect.x, rect.y, rect.width, rect.height);
				}
				b = b.tail;
			}
		}

		// 3) Go through the whole drawing list in re-render all the known graphics
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

		// 4) Draw the drawing rects.
		// TODO (Simon) : Dump this on a different context!
		if(_debugging && clearRects.nonEmpty) {
			_context.save();
			
			_context.fillStyle = "rgba(255, 0, 0, 0.2)";

			var b : IList<Rectangle> = clearRects;
			while(b.nonEmpty) {
				var cr : Rectangle = b.head;
				_context.fillRect(cr.x, cr.y, cr.width, cr.height);
				b = b.tail;
			}

			_context.restore();
		}
	}

	private function markInvalidatedGraphics(graphics : Graphics, list : IList<Graphics>) : Void {
		var p : IList<Graphics> = list;
		while(p.nonEmpty) {
			var other : Graphics = p.head;

			// Don't test the bounds if they're the same instance.
			if(graphics != other && !other.isDirty) {
				// Work out if any bounds overlap.
				var gb : Rectangle = graphics.bounds;
				var gpb : Rectangle = graphics.previousBounds;
				var ob : Rectangle = other.bounds;
				var opb : Rectangle = other.previousBounds;

				if(	gb.intersects(ob) || 
					gpb.intersects(ob) ||
					gb.intersects(opb) || 
					gpb.intersects(opb)) {

					other.invalidate();
				}
			}

			p = p.tail;
		}
	}

	private function markIntersections(rect : Rectangle, list : IList<Rectangle>) : IList<Rectangle> {
		var result : IList<Rectangle> = list;

		var added : Bool = false;
/*
		var p : IList<Rectangle> = list;
		while(p.nonEmpty) {
			var r : Rectangle = p.head;

			if(rect.intersects(r)) {
				added = true;

				// expand current item
				if(rect.x < r.x) r.x = rect.x;
				if(rect.y < r.y) r.y = rect.y;
				if(rect.right > r.right) r.width = rect.right - r.x;
				if(rect.height > r.height) r.height = rect.bottom - r.y;

				break;
			} 

			p = p.tail;
		}*/

		if(!added) {
			result = result.prepend(rect.clone());
		}

		return result;
	}

	private function getBounds() : Rectangle {
		return _bounds;
	}

	private function getSize() : Int {
		return _list.size;
	}
}