package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Point;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.IGraphicsCommand;
import funk.gui.js.core.display.commands.GraphicsBeginFill;
import funk.gui.js.core.display.commands.GraphicsCircle;
import funk.gui.js.core.display.commands.GraphicsClear;
import funk.gui.js.core.display.commands.GraphicsCreateText;
import funk.gui.js.core.display.commands.GraphicsEndFill;
import funk.gui.js.core.display.commands.GraphicsGradientFill;
import funk.gui.js.core.display.commands.GraphicsMoveTo;
import funk.gui.js.core.display.commands.GraphicsLineTo;
import funk.gui.js.core.display.commands.GraphicsRectangle;
import funk.gui.js.core.display.commands.GraphicsRestore;
import funk.gui.js.core.display.commands.GraphicsRoundedRectangle;
import funk.gui.js.core.display.commands.GraphicsRoundedRectangleComplex;
import funk.gui.js.core.display.commands.GraphicsSave;
import funk.gui.js.core.display.commands.GraphicsTranslate;
import funk.option.Any;
import funk.option.Option;

import js.w3c.html5.Canvas2DContext;

using funk.collections.immutable.Nil;
using funk.option.Any;

class Graphics {

	inline private static var DEFAULT_MIN_VALUE : Float = 0.0;

	inline private static var DEFAULT_MAX_VALUE : Float = 999999999.0;

	public var commands(getCommands, never) : IList<IGraphicsCommand>;

	public var bounds(getBounds, never) : Rectangle;

	public var previousBounds(getPreviousBounds, never) : Rectangle;

	public var isDirty(getDirty, never) : Bool;

	private var _list : IList<IGraphicsCommand>;

	private var _tx : Float;

	private var _ty : Float;

	private var _bounds : Rectangle;

	private var _previousBounds : Rectangle;

	private var _dirty : Bool;

	public function new(){
		_dirty = false;
		_bounds = new Rectangle(DEFAULT_MAX_VALUE, DEFAULT_MAX_VALUE, DEFAULT_MIN_VALUE, DEFAULT_MIN_VALUE);
		_previousBounds = new Rectangle();

		_list = nil.list();

		_tx = 0;
		_ty = 0;
	}

	public function clear() : Void {
		invalidate();
		
		_tx = 0;
		_ty = 0;

		if( _bounds.x == DEFAULT_MAX_VALUE && _bounds.y == DEFAULT_MAX_VALUE &&
			_bounds.width == DEFAULT_MIN_VALUE && _bounds.height == DEFAULT_MIN_VALUE) {
			_previousBounds.setValues(0, 0, 0, 0);
		} else {
			_previousBounds.setValues(_bounds.x, _bounds.y, _bounds.width, _bounds.height);	
		}
		
		_list = nil.list();
		_list = _list.append(new GraphicsClear(_previousBounds));

		_bounds.setValues(DEFAULT_MAX_VALUE, DEFAULT_MAX_VALUE, DEFAULT_MIN_VALUE, DEFAULT_MIN_VALUE);
	}

	public function endFill() : Void {
		invalidate();

		_list = _list.append(new GraphicsEndFill());
	}

	public function beginFill(color : Int, ?alpha : Float = 1.0) : Void {
		invalidate();

		_list = _list.append(new GraphicsBeginFill(color, alpha));
	}

	public function beginGradientFill(	colors : Array<Int>, 
										alphas : Array<Float>, 
										ratios : Array<Float>) : Void {
		invalidate();

		_list = _list.append(new GraphicsGradientFill(colors, alphas, ratios));
	}

	public function createText(text : String, rect : Rectangle) : Void {
		invalidate();

		_list = _list.append(new GraphicsCreateText(text, new Point(rect.x, rect.y)));

		var width : Float = rect.width;
		var height : Float = rect.height;

		// Expand the drawing rect.
		var tx : Float = _tx + rect.x;
		var ty : Float = _ty + rect.y;

		if(tx < _bounds.x) _bounds.x = tx;
		if(ty < _bounds.y) _bounds.y = ty;
		if(width > _bounds.width) _bounds.width = width;
		if(height > _bounds.height) _bounds.height = height;
	}

	public function drawRect(x : Float, y : Float, width : Float, height : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsRectangle(x, y, width, height));

		// Expand the drawing rect.
		var tx : Float = _tx + x;
		var ty : Float = _ty + y;

		if(tx < _bounds.x) _bounds.x = tx;
		if(ty < _bounds.y) _bounds.y = ty;
		if(width > _bounds.width) _bounds.width = width;
		if(height > _bounds.height) _bounds.height = height;
	}

	public function drawRoundRect(	x : Float, 
									y : Float, 
									width : Float, 
									height : Float, 
									radius : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsRoundedRectangle(x, y, width, height, radius));

		// Expand the drawing round rect.
		var tx : Float = _tx + x;
		var ty : Float = _ty + y;

		if(tx < _bounds.x) _bounds.x = tx;
		if(ty < _bounds.y) _bounds.y = ty;
		if(width > _bounds.width) _bounds.width = width;
		if(height > _bounds.height) _bounds.height = height;
	}

	public function drawRoundRectComplex(	x : Float, 
											y : Float, 
											width : Float, 
											height : Float, 
											topLeftRadius : Float,
											topRightRadius : Float,
											bottomLeftRadius : Float,
											bottomRightRadius : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsRoundedRectangleComplex(	x, 
																	y, 
																	width, 
																	height, 
																	topLeftRadius,
																	topRightRadius,
																	bottomLeftRadius,
																	bottomRightRadius));

		// Expand the drawing round rect.
		var tx : Float = _tx + x;
		var ty : Float = _ty + y;

		if(tx < _bounds.x) _bounds.x = tx;
		if(ty < _bounds.y) _bounds.y = ty;
		if(width > _bounds.width) _bounds.width = width;
		if(height > _bounds.height) _bounds.height = height;
	}

	public function drawCircle(x : Float, y : Float, radius : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsCircle(x, y, radius));

		var r : Float = radius * 2.0;

		var tx : Float = _tx + x - radius;
		var ty : Float = _ty + y - radius;

		if(tx < _bounds.x) _bounds.x = tx;
		if(ty < _bounds.y) _bounds.y = ty;
		if(r > _bounds.width) _bounds.width = r;
		if(r > _bounds.height) _bounds.height = r;
	}

	public function restore() : Void {
		invalidate();

		_list = _list.append(new GraphicsRestore());
	}

	public function save() : Void {
		invalidate();

		_list = _list.append(new GraphicsSave());
	}

	public function translate(x : Float, y : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsTranslate(x, y));

		_tx = x;
		_ty = y;

		if(x < _bounds.x) _bounds.x = x;
		if(y < _bounds.y) _bounds.y = y;
	}

	public function invalidate() : Void {
		_dirty = true;
	}

	public function validated() : Void {
		_dirty = false;

		_previousBounds.setValues(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
	}

	private function getCommands() : IList<IGraphicsCommand> {
		return _list;
	}

	private function getBounds() : Rectangle {
		return _bounds;
	}

	private function getPreviousBounds() : Rectangle {
		return _previousBounds;
	}

	private function getDirty() : Bool {
		return _dirty;
	}
}