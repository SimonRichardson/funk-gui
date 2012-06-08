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
	
	private var _window : Window;

	private var _document : HTMLDocument;
	
	private var _context : HTMLCanvasElement;
	
	public function new(){
	}
	
	public function onRenderManagerInitialize(root : Root<HTMLCanvasElement>) : Void {
		_window = untyped __js__("window");
		_document = CommonJS.getHtmlDocument();
		
		_context = CommonJS.newElement("canvas", _document);
		_context.id = "gui-hx";
		_context.className = "gui-hx-canvas";
		
		_document.body.appendChild(_context);
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
		trace("RenderManger - Render");
	}

	private function get_context() : HTMLCanvasElement {
		return _context;
	}
}
