package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.IGraphicsCommand;
import funk.gui.js.core.display.text.TextLineMetrics;
import funk.option.Any;

import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

using funk.collections.immutable.Nil;
using funk.option.Any;

class Painter {

	public var bounds(getBounds, never) : Rectangle;

	public var size(getSize, never) : Int;

	public var debug(getDebug, setDebug) : Bool;

	private static var _staticContext : CanvasRenderingContext2D;

	private static var _staticSpanElement : HTMLSpanElement;

	private static var _staticTextHeights : Hash<Int> = new Hash<Int>();

	private var _context : CanvasRenderingContext2D;

	private var _bounds : Rectangle;

	private var _list : IList<Graphics>;

	private var _highQuality : Bool;

	private var _overdraw : Bool;

	private var _mergeIntersections : Bool;

	private var _debug : Bool;

	private var _debugContext : CanvasRenderingContext2D;

	private var _debugClearIteration : Int;

	public function new(	context : CanvasRenderingContext2D, 
							debugContext : CanvasRenderingContext2D,
							highQuality : Bool) {		
		_context = context;
		_debugContext = debugContext;
		_highQuality = highQuality;

		_list = nil.list();
		_bounds = new Rectangle();

		_debug = false;

		_overdraw = false;
		_mergeIntersections = true;

		// We need to keep a reference of this for easy quick measuring of text.
		_staticContext = _context;

		if(_staticSpanElement.isEmpty()){
			var document : HTMLDocument = CommonJS.getHtmlDocument();
			_staticSpanElement = CommonJS.newElement("span", document);
			_staticSpanElement.style.position = "absolute";
			document.body.appendChild(_staticSpanElement);
		}
	}

	public static function measureText(text : String, metrics : TextLineMetrics) : Void {
		if(_staticContext.isDefined()) {
			// TODO : Passing the font description
			_staticContext.font = "14px sans-serif";
			var nativeMetrics : TextMetrics = _staticContext.measureText(text);
			metrics.width = nativeMetrics.width;
		}

		// TODO : Pass in the font details
		var cssFont : String = "14px sans-serif";
		if(_staticTextHeights.exists(cssFont)) {
			metrics.height = _staticTextHeights.get(cssFont);
		} else if(_staticSpanElement.isDefined()) {
			_staticSpanElement.font = cssFont;
			_staticSpanElement.textContent = text;

			metrics.height = _staticSpanElement.offsetHeight;

			_staticSpanElement.textContent = "";
		}
	}

	public function add(graphics : Graphics) : Void {
		_list = _list.append(graphics);
	}

	public function addAll(graphics : IList<Graphics>) : Void {
		_list = _list.appendAll(graphics);
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
					var preBounds : Rectangle = graphics.previousBounds;
					clearRects = markIntersections(preBounds, clearRects);
				}
				p = p.tail;
			}

			// TODO (Simon) : Work out if the rect angles are many and if so - possibly merge.
			// We could self loop on clearRects with markIntersections so we end up with 
			// a tighter list.

			// 2B) If we've unified clearRects we could be over writting some extra graphics
			// which could prevent redraws.
			if(_mergeIntersections) {
				// Go back through and work out which ones have now been invalidated by the new
				// intersections.
				var p : IList<Graphics> = _list;
				while(p.nonEmpty) {
					graphics = p.head;

					if(!graphics.isDirty) {
						remarkInvalidatedGraphics(graphics, clearRects);						
					}

					p = p.tail;
				}
			}

			// 2C) Clear the context
			if(!_overdraw) {
				var b : IList<Rectangle> = clearRects;
				while(b.nonEmpty) {
					var rect : Rectangle = b.head;
					if(rect.width > 0 && rect.height > 0) {
						_context.clearRect(rect.x, rect.y, rect.width, rect.height);
					}
					b = b.tail;
				}
			}
		}

		// 3) Go through the whole drawing list in re-render all the known graphics
		p = _list;
		while(p.nonEmpty) {
			graphics = p.head;

			// The graphics hasn't been invalidated so just continue.
			if(graphics.isDirty && graphics.commands.isDefined()) {

				var hasFill : Bool = false;
				var hasPathOpen : Bool = false;

				// Render the commands.
				var commands : IList<IGraphicsCommand> = graphics.commands;
				for(c in commands) {
					var command : IGraphicsCommand = c;

					switch(command.type) {
						case BEGIN_FILL(type): 
							hasFill = true;
							switch(type) {
								case SOLID(color, alpha):
									_context.fillStyle = StringTools.hex(color, 6);
								case GRADIENT(colors, alphas, ratios):
									var gHeight = graphics.bounds.height;
									var gradient = _context.createLinearGradient(0, 0, 0, gHeight);
									var colorTotal = colors.length;
									for(k in 0...colorTotal) {
										var col = StringTools.hex(colors[k], 6);
										gradient.addColorStop(ratios[k], col);
									}
									_context.fillStyle = gradient;
							}
						case CIRCLE(x, y, radius):
							if(!hasPathOpen) {
								hasPathOpen = true;
								_context.beginPath();
							}
							_context.arc(x, y, radius, 0, Math.PI * 2, hasFill);
						case CLEAR(bounds):
							hasFill = false;
							hasPathOpen = false;
						case CREATE_TEXT(text, point):
							_context.font = "14px sans-serif";
							_context.fillText(text, point.x, point.y);
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
						case ROUNDED_RECT(x, y, width, height, radius):
							if(hasPathOpen) {
								hasPathOpen = false;
								_context.closePath();
							}

							var tl : Float, tr : Float, bl : Float, br : Float;
							switch(radius) {
								case ALL(r):  tl = tr = bl = br = r;
								case EACH(tlr, trr, blr, brr):
									tl = tlr;
									tr = trr;
									bl = blr;
									br = brr;
							}

							_context.beginPath();
							_context.moveTo(x + tl, y);
							_context.lineTo(x + width - tr, y);
							_context.quadraticCurveTo(x + width, y, x + width, y + tr);
							_context.lineTo(x + width, y + height - br);
							_context.quadraticCurveTo(x + width, y + height, x + width - br, y + height);
							_context.lineTo(x + bl, y + height);
							_context.quadraticCurveTo(x, y + height, x, y + height - bl);
							_context.lineTo(x, y + tl);
							_context.quadraticCurveTo(x, y, x + tl, y);
							_context.closePath();

						case TRANSLATE(x, y):
							_context.translate(x, y);
					}
				}

				graphics.validated();
			}

			p = p.tail;
		}

		// 4) Draw the drawing rects.
		if(_debug && clearRects.nonEmpty) {
			_debugContext.save();
			
			if(_debugClearIteration++ % 20 == 0) {
				_debugContext.clearRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
			}

			_debugContext.fillStyle = "rgba(255, 0, 0, 0.2)";

			var b : IList<Rectangle> = clearRects;
			while(b.nonEmpty) {
				var cr : Rectangle = b.head;

				_debugContext.fillRect(cr.x, cr.y, cr.width, cr.height);
				b = b.tail;
			}

			_debugContext.restore();
		}
	}

	public function iterator() : Iterator<Graphics> {
		return _list.iterator();
	}

	private function markInvalidatedGraphics(graphics : Graphics, list : IList<Graphics>) : Void {
		if(list.nonEmpty) {
			// Cache these here.
			var gb : Rectangle = graphics.bounds;
			var gpb : Rectangle = graphics.previousBounds;

			var p : IList<Graphics> = list;
			while(p.nonEmpty) {
				var other : Graphics = p.head;

				// Don't test the bounds if they're the same instance.
				if(graphics != other && !other.isDirty) {
					// Work out if any bounds overlap.
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
	}

	private function remarkInvalidatedGraphics(graphics : Graphics, list : IList<Rectangle>) : Void {
		if(list.nonEmpty) {
			// Cache these here.
			var gb : Rectangle = graphics.bounds;
			var gpb : Rectangle = graphics.previousBounds;

			var p : IList<Rectangle> = list;
			while(p.nonEmpty) {
				var other : Rectangle = p.head;
				if(gb.intersects(other) || gpb.intersects(other)) {
					graphics.invalidate();
				}

				p = p.tail;
			}
		}
	}

	private function markIntersections(rect : Rectangle, list : IList<Rectangle>) : IList<Rectangle> {
		var result : IList<Rectangle> = list;

		if(_mergeIntersections) {
			var added : Bool = false;
			
			var p : IList<Rectangle> = result;
			while(p.nonEmpty) {
				var r : Rectangle = p.head;

				if(r.intersects(rect)) {
					added = true;

					union(r, rect);

					break;
				} 

				p = p.tail;
			}

			if(!added) {
				result = result.prepend(rect.clone());
			}
		} else {
			result = result.prepend(rect);
		}

		return result;
	}

	inline private function union(a : Rectangle, b : Rectangle) : Void {
		var x : Float = a.x < b.x ? a.x : b.x;
    	var y : Float = a.y < b.y ? a.y : b.y;
    	var w : Float = a.right > b.right ? a.right : b.right;
    	var h : Float = a.bottom > b.bottom ? a.bottom : b.bottom;

    	a.x = x;
    	a.y = y;
    	a.width = w - x;
    	a.height = h - y;
	}

	private function getBounds() : Rectangle {
		return _bounds;
	}

	private function getSize() : Int {
		return _list.size;
	}

	private function getDebug() : Bool {
		return _debug;
	}

	private function setDebug(value : Bool) : Bool {
		_debug = value;

		if(_debug) {
			_debugClearIteration = 0;
			_debugContext.clearRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
		}

		return _debug;
	}
}