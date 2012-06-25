package funk.gui.js.dom.display;

import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.gui.core.ComponentView;
import funk.gui.core.IComponentView;
import funk.gui.js.core.display.Graphics;
import funk.gui.js.core.display.IGraphicsView;
import funk.option.Any;

import js.Dom;
import js.w3c.DOMTypes;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

using funk.collections.immutable.ListUtil;
using funk.option.Any;

class GraphicsComponentView extends ComponentView, implements IGraphicsView {

	public var element(getElement, never) : HTMLElement;

	public var graphics(get_graphics, never) : Graphics;

	public var graphicsList(getGraphicsList, never) : IList<Graphics>;

	private var _element : HTMLElement;

	private var _graphics : Graphics;

	private var _graphicsList : IList<Graphics>;

	public function new() {
		super();

		_element = CommonJS.newElement("div", CommonJS.getHtmlDocument());

		_graphics = new Graphics(this);
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

	private function getElement() : HTMLElement {
		return _element;
	}

	private function get_graphics() : Graphics {
		return _graphics;
	}

	private function getGraphicsList() : IList<Graphics> {
		return _graphicsList;
	}
}