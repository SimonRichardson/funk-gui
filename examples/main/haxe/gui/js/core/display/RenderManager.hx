package gui.js.core.display;

import funk.gui.core.display.IComponentRenderManager;
import funk.gui.Root;

import js.Dom;
import js.Lib;

class RenderManager implements IComponentRenderManager<HtmlDom> {
	
	inline public static var ELEMENT_ID : String = "gui-hx";
	
	public var context(get_context, never) : HtmlDom;
	
	private var _document : Document;
	
	private var _element : HtmlDom; 
	
	private var _canvas : HtmlDom;
	
	private var _context : HtmlDom;
	
	public function new(){
	}
	
	public function onRenderManagerInitialize(root : Root<HtmlDom>) : Void {
		_document = Lib.document;
		_element = _document.getElementById(ELEMENT_ID);
		
		_canvas = _document.createElement("canvas");
		_canvas.setAttribute("context", "2d");
		_element.appendChild(_canvas);
		
		_context = _canvas;
	}
	
	public function onRenderManagerCleanup() : Void {
		_canvas = null;
		_element = null;
		_document = null;
	}
	
	public function invalidate() : Void {
		
	}
	
	private function get_context() : HtmlDom {
		return _context;
	}
}
