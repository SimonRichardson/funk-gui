package funk.gui.js.dom.display;

import funk.signal.Signal2;

import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.display.IComponentRenderManagerObserver;
import funk.gui.core.events.ContainerEvent;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.gui.core.IContainerObserver;

import funk.gui.js.core.event.Events;

import js.Dom;
import js.w3c.DOMTypes;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

class RenderManager<E : HTMLElement>  implements IComponentRenderManager<E>, 
									  implements IContainerObserver {
	
	inline public static var ELEMENT_ID : String = "gui-hx";
	
	public var context(get_context, never) : E;

	public var debug(get_debug, set_debug) : Bool;
	
	private var _root : IComponentRoot<E>;

	private var _window : Window;

	private var _document : HTMLDocument;

	private var _context : E;

	private var _painter : Painter;
	
	private var _signal : ISignal2<IComponentRenderManager<E>, ComponentRenderManagerUpdateType>;

	private var _rootModified : Bool;

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
		_root.addContainerObserver(this);

		_window = untyped __js__("window");
		_document = CommonJS.getHtmlDocument();

		_painter = new Painter();
		
		resizeTo(_window.innerWidth, _window.innerHeight);
	}
	
	public function onRenderManagerCleanup() : Void {
		_window = null;
		_document = null;
		_context = null;
	}
	
	public function invalidate() : Void {
		Events.render.add(render);	
	}

	public function resizeTo(width : Float, height : Float) : Void {
		var nw : Int = Std.int(width);
		var nh : Int = Std.int(height);
		
	}

	public function onContainerUpdate(event : ContainerEvent) : Void {
		switch(event.type) {
			case ContainerEventType.COMPONENT_ADDED:
				var component : IComponent = event.component;
				if(Std.is(component.view, GraphicsComponentView)) {
					var graphicsComponentView : GraphicsComponentView = cast component.view;
					_document.body.appendChild(graphicsComponentView.element);
					_rootModified = true;
				}
		}
	}
	
	private function render() : Void {
		notify(PRE_RENDER);

		// 1) Only re-add contents after the root has been modified.
		if(_rootModified) {
			// Remove all the components (quicker) and re-add.
			_painter.removeAll();

			for(component in _root) {
				if(Std.is(component.view, GraphicsComponentView)) {
					var view : GraphicsComponentView = cast component.view;
					_painter.addAll(view.graphicsList);
				}
			}

			_rootModified = false;
		}

		// 2) Render the contents.
		_painter.render();

		notify(POST_RENDER);
	}

	private function notify(type : ComponentRenderManagerUpdateType) : Void {
		_signal.dispatch(this, type);
	}

	private function get_context() : E {
		return _context;
	}

	private function get_debug() : Bool {
		return false;
	}

	private function set_debug(value : Bool) : Bool {
		resizeTo(_window.innerWidth, _window.innerHeight);
		return false;
	}
}
