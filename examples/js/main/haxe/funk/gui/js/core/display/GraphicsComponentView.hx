package funk.gui.js.core.display;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.gui.core.ComponentView;
import funk.gui.core.IComponentView;
import funk.option.Any;

using funk.collections.immutable.ListUtil;
using funk.option.Any;

class GraphicsComponentView extends ComponentView {

	public var graphics(getGraphics, never) : Graphics;

	public var graphicsList(getGraphicsList, never) : IList<Graphics>;

	private var _graphics : Graphics;

	private var _graphicsList : IList<Graphics>;

	public function new() {
		super();

		_graphics = new Graphics();
		_graphicsList = _graphics.toList();
	}

	public function addView(view : IComponentView) : Void {
		if(Std.is(view, GraphicsComponentView)) {
			var gView : GraphicsComponentView = cast view;
			var gViewGraphics : Graphics = gView.graphics;

			_graphicsList = _graphicsList.append(gView.graphics);
		}
	}

	public function removeView(view : IComponentView) : Void {
		if(Std.is(view, GraphicsComponentView)) {
			var gView : GraphicsComponentView = cast view;
			var gViewGraphics : Graphics = gView.graphics;
			
			_graphicsList = _graphicsList.filterNot(function(g : Graphics) : Bool {
				return gViewGraphics == g;
			});
		}
	}

	override private function moveTo(x : Float, y : Float) : Void {
		super.moveTo(x, y);

		var p : IList<Graphics> = _graphicsList;
		while(p.nonEmpty) {
			var g : Graphics = p.head;
			g.invalidate();

			p = p.tail;
		}
	}

	private function getGraphics() : Graphics {
		return _graphics;
	}

	private function getGraphicsList() : IList<Graphics> {
		return _graphicsList;
	}
}