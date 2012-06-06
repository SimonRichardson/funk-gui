package gui.js.core.display;

import funk.gui.core.display.IComponentRenderManager;
import funk.gui.Root;

import js.Dom;
import js.Lib;

class RenderManager implements IComponentRenderManager {
	
	inline public static var ELEMENT_ID : String = "gui-hx";
	
	private var _document : Document;
	
	private var _element : HtmlDom; 
	
	private var _canvas : HtmlDom;
	
	public function new(){
		
	}
	
	public function onRenderManagerInitialize(root : Root) : Void {
		_document = Lib.document;
		_element = _document.getElementById(ELEMENT_ID);
		
		_canvas = _document.createElement("canvas");
		_canvas.setAttribute("context", "2d");
		_element.appendChild(_canvas);
	}
	
	public function onRenderManagerCleanup() : Void {
		_element = null;
		_document = null;
	}
}
