package funk.gui.js.dom.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Any;

import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.IGraphicsCommand;

import js.w3c.css.CSSOM;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

using funk.collections.immutable.Nil;
using funk.option.Any;

class Painter {

	public var bounds(getBounds, never) : Rectangle;

	public var size(getSize, never) : Int;

	public var debug(getDebug, setDebug) : Bool;

	private var _bounds : Rectangle;

	private var _list : IList<Graphics>;

	private var _debug : Bool;

	public function new() {		
		_list = nil.list();
		_bounds = new Rectangle();
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

		var p : IList<Graphics> = _list;
		while(p.nonEmpty) {
			graphics = p.head;

			// The graphics hasn't been invalidated so just continue.
			if(graphics.isDirty && graphics.commands.isDefined()) {

				var view : GraphicsComponentView = cast graphics.view;
				var element : HTMLElement = view.element;
				var style : CSSStyleDeclaration = element.style;

				style.position = "absolute";
				style.display = "block";

				var hasFill : Bool = false;
				var hasPathOpen : Bool = false;

				// Render the commands.
				var commands : IList<IGraphicsCommand> = graphics.commands;
				for(c in commands) {
					var command : IGraphicsCommand = c;

					switch(command.type) {
						case BEGIN_FILL(type): 
							switch(type) {
								case SOLID(color, alpha):
									style.backgroundColor = "#" + StringTools.hex(color, 6);
								case GRADIENT(colors, alphas, ratios):
							}
						case CIRCLE(x, y, radius):
							// TODO (Add border radius)
							Reflect.setProperty(style, "borderRadius", "50%");
							style.width = (radius) + "px";
							style.height = (radius ) + "px";
						case CLEAR(bounds):
						case CREATE_TEXT(text, font, point):
						case END_FILL:
						case MOVE_TO(x, y):
						case LINE_TO(x, y):
						case SAVE:
						case RECT(x, y, width, height):
							style.width = width + "px";
							style.height = height + "px";
						case RESTORE:
						case ROUNDED_RECT(x, y, width, height, radius):
						case TRANSLATE(x, y):
							style.left = x + "px";
							style.top = y + "px";
					}
				}

				graphics.validated();
			}

			p = p.tail;
		}
	}

	public function iterator() : Iterator<Graphics> {
		return _list.iterator();
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
		return _debug;
	}
}