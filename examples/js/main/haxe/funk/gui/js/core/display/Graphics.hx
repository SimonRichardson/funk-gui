package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.gui.js.core.display.IGraphicsCommand;
import funk.gui.js.core.display.commands.GraphicsBeginFill;
import funk.gui.js.core.display.commands.GraphicsEndFill;
import funk.gui.js.core.display.commands.GraphicsMoveTo;
import funk.gui.js.core.display.commands.GraphicsLineTo;
import funk.gui.js.core.display.commands.GraphicsRectangle;
import funk.gui.js.core.display.commands.GraphicsRestore;
import funk.gui.js.core.display.commands.GraphicsSave;
import funk.gui.js.core.display.commands.GraphicsTranslate;

using funk.collections.immutable.Nil;

class Graphics {

	public var commands(getCommands, never) : IList<IGraphicsCommand>;

	private var _list : IList<IGraphicsCommand>;

	public function new(){
		_list = nil.list();
	}

	public function clear() : Void {
		_list = nil.list();
	}

	public function endFill() : Void {
		_list = _list.prepend(new GraphicsEndFill());
	}

	public function beginFill(color : Int, ?alpha : Float) : Void {
		_list = _list.prepend(new GraphicsBeginFill(color, alpha));
	}

	public function drawRect(x : Float, y : Float, width : Float, height : Float) : Void {
		_list = _list.prepend(new GraphicsRectangle(x, y, width, height));
	}

	public function restore() : Void {
		_list = _list.prepend(new GraphicsRestore());
	}

	public function save() : Void {
		_list = _list.prepend(new GraphicsSave());
	}

	public function translate(x : Float, y : Float) : Void {
		_list = _list.prepend(new GraphicsTranslate(x, y));
	}

	private function getCommands() : IList<IGraphicsCommand> {
		return _list.reverse;
	}
}