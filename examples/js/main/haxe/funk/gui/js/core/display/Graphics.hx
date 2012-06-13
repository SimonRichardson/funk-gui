package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.core.geom.Rectangle;
import funk.gui.js.core.display.IGraphicsCommand;
import funk.gui.js.core.display.commands.GraphicsBeginFill;
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

	public var isDirty(getDirty, never) : Bool;

	private var _list : IList<IGraphicsCommand>;

	private var _tx : Float;

	private var _ty : Float;

	private var _bounds : Rectangle;

	private var _clearBounds : Rectangle;

	private var _dirty : Bool;

	public function new(){
		_dirty = false;
		_bounds = new Rectangle(DEFAULT_MAX_VALUE, DEFAULT_MAX_VALUE, DEFAULT_MIN_VALUE, DEFAULT_MIN_VALUE);
		_clearBounds = new Rectangle();

		_list = nil.list();
	}

	public function clear() : Void {
		invalidate();
		
		_tx = 0;
		_ty = 0;

		_clearBounds.setValues(_bounds.x, _bounds.y, _bounds.width, _bounds.height);

		_list = nil.list();
		_list = _list.append(new GraphicsClear(_clearBounds));

		_bounds.setValues(DEFAULT_MAX_VALUE, DEFAULT_MAX_VALUE, DEFAULT_MIN_VALUE, DEFAULT_MIN_VALUE);
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

		_bounds.x = _tx + x < _bounds.x ? _tx + x : _bounds.x;
		_bounds.y = _ty + y < _bounds.y ? _ty + y : _bounds.y;
		_bounds.width = width > _bounds.width ? width : _bounds.width;
		_bounds.height = height > _bounds.height ? height : _bounds.height;
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

		_bounds.x = x < _bounds.x ? x : _bounds.x;
		_bounds.y = y < _bounds.y ? y : _bounds.y;
	}

	public function invalidate() : Void {
		_dirty = true;
	}

	public function validated() : Void {
		_dirty = false;
	}

	private function getCommands() : IList<IGraphicsCommand> {
		return _list;
	}

	private function getBounds() : Rectangle {
		return _bounds;
	}

	private function getDirty() : Bool {
		return _dirty;
	}

	public function toString() : String {
		return Std.format("[Graphics (id:$id)]");
	}
}