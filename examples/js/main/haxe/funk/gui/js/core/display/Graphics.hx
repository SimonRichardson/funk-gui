package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.IGraphicsCommand;
import funk.gui.js.core.display.commands.GraphicsBeginFill;
import funk.gui.js.core.display.commands.GraphicsCircle;
import funk.gui.js.core.display.commands.GraphicsClear;
import funk.gui.js.core.display.commands.GraphicsEndFill;
import funk.gui.js.core.display.commands.GraphicsMoveTo;
import funk.gui.js.core.display.commands.GraphicsLineTo;
import funk.gui.js.core.display.commands.GraphicsRectangle;
import funk.gui.js.core.display.commands.GraphicsRestore;
import funk.gui.js.core.display.commands.GraphicsSave;
import funk.gui.js.core.display.commands.GraphicsTranslate;

using funk.collections.immutable.Nil;

class Graphics {

	inline private static var DEFAULT_MIN_VALUE : Float = -1.0;

	inline private static var DEFAULT_MAX_VALUE : Float = 999999999.0;

	public var id : Int;

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
		_bounds = new Rectangle(DEFAULT_MAX_VALUE, DEFAULT_MAX_VALUE, 0, 0);
		_previousBounds = new Rectangle();
	}

	public function clear() : Void {
		invalidate();
		
		_tx = 0;
		_ty = 0;

		_previousBounds.setValues(_bounds.x, _bounds.y, _bounds.width, _bounds.height);

		_list = nil.list();
		_list = _list.append(new GraphicsClear(_previousBounds));

		_bounds.setValues(DEFAULT_MAX_VALUE, DEFAULT_MAX_VALUE, 0, 0);
	}

	public function endFill() : Void {
		invalidate();

		_list = _list.append(new GraphicsEndFill());
	}

	public function beginFill(color : Int, ?alpha : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsBeginFill(color, alpha));
	}

	public function drawRect(x : Float, y : Float, width : Float, height : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsRectangle(x, y, width, height));

		// Expand the drawing rect.
		if(_tx + x < _bounds.x) _bounds.x = _tx + x;
		if(_ty + y < _bounds.y) _bounds.y = _ty + y;
		if(width > _bounds.width) _bounds.width = width;
		if(height > _bounds.height) _bounds.height = height;
	}

	public function drawCircle(x : Float, y : Float, radius : Float) : Void {
		invalidate();

		_list = _list.append(new GraphicsCircle(x, y, radius));

		var r : Float = radius * 2.0;

		if(_tx + x < _bounds.x) _bounds.x = _tx + x;
		if(_ty + y < _bounds.y) _bounds.y = _ty + y;
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

		//_previousBounds.setValues(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
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

	public function toString() : String {
		return Std.format("[Graphics (id:$id)]");
	}
}