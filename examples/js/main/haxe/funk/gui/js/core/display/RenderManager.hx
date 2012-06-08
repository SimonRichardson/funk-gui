package funk.gui.js.core.display;

import funk.gui.core.display.IComponentRenderManager;
import funk.gui.Root;
import funk.gui.js.core.event.Events;

import js.Dom;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

class RenderManager implements IComponentRenderManager<HTMLCanvasElement> {
	
	inline public static var ELEMENT_ID : String = "gui-hx";
	
	public var context(get_context, never) : HTMLCanvasElement;
	
	private var _root : Root<HTMLCanvasElement>;

	private var _window : Window;

	private var _document : HTMLDocument;
	
	private var _context : HTMLCanvasElement;

	private var _painter : Painter;
	
	public function new(){
	}
	
	public function onRenderManagerInitialize(root : Root<HTMLCanvasElement>) : Void {
		_root = root;

		_window = untyped __js__("window");
		_document = CommonJS.getHtmlDocument();
		
		_context = CommonJS.newElement("canvas", _document);
		_context.id = "gui-hx";
		_context.className = "gui-hx-canvas";
		
		_document.body.appendChild(_context);

		_painter = new Painter(_context.getContext("2d"));
	}
	
	public function onRenderManagerCleanup() : Void {
		_window = null;
		_document = null;
		_context = null;
	}
	
	public function invalidate() : Void {
		Events.render.add(render, true);
	}
	
	private function render() : Void {
		for(component in _root) {
			if(Std.is(component.view, GraphicsComponentView)) {
				var view : GraphicsComponentView = cast component.view;
				_painter.add(view.graphics, view.bounds);
			}
		}
		
		_painter.render();
	}

	private function get_context() : HTMLCanvasElement {
		return _context;
	}
}
