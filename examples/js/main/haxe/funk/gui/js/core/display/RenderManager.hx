package funk.gui.js.core.display;

import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.display.IComponentRenderManagerObserver;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.gui.js.core.event.Events;
import funk.signal.Signal2;

import js.Dom;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

class RenderManager<E : HTMLCanvasElement> implements IComponentRenderManager<E> {
	
	inline public static var ELEMENT_ID : String = "gui-hx";
	
	public var context(get_context, never) : E;
	
	private var _root : IComponentRoot<E>;

	private var _window : Window;

	private var _document : HTMLDocument;
	
	private var _context : E;

	private var _painter : Painter;

	private var _signal : ISignal2<IComponentRenderManager<E>, ComponentRenderManagerUpdateType>;
			
	public function new(){
		_signal = new Signal2<IComponentRenderManager<E>, ComponentRenderManagerUpdateType>();
	}
	
	public function addRenderManagerObserver(observer : IComponentRenderManagerObserver<E>) : 
																IComponentRenderManagerObserver<E> {
        _signal.add(observer.onComponentRenderManagerUpdate);
        return observer;
	}

	public function removeRenderManagerObserver(observer : IComponentRenderManagerObserver<E>) : 
																IComponentRenderManagerObserver<E> {
        _signal.remove(observer.onComponentRenderManagerUpdate);
        return observer;
	}
	
	public function onRenderManagerInitialize(root : IComponentRoot<E>) : Void {
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
		notify(PRE_RENDER);

		for(component in _root) {
			if(Std.is(component.view, GraphicsComponentView)) {
				var view : GraphicsComponentView = cast component.view;
				_painter.add(view.graphics, view.bounds);
			}
		}
		
		_painter.render();

		notify(POST_RENDER);
	}

	private function notify(type : ComponentRenderManagerUpdateType) : Void {
		_signal.dispatch(this, type);
	}

	private function get_context() : E {
		return _context;
	}
}
