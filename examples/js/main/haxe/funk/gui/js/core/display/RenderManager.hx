package funk.gui.js.core.display;

import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.display.IComponentRenderManagerObserver;
import funk.gui.core.events.ContainerEvent;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;
import funk.gui.core.IContainerObserver;
import funk.gui.js.core.event.Events;
import funk.signal.Signal2;

import js.Dom;
import js.w3c.DOMTypes;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;

class RenderManager<E : HTMLCanvasElement>  implements IComponentRenderManager<E>, 
											implements IContainerObserver {
	
	inline public static var ELEMENT_ID : String = "gui-hx";
	
	public var context(get_context, never) : E;

	public var debug(get_debug, set_debug) : Bool;
	
	private var _root : IComponentRoot<E>;

	private var _window : Window;

	private var _document : HTMLDocument;
	
	private var _context : E;

	private var _canvas2dContext : CanvasRenderingContext2D;

	private var _debugContext : E;

	private var _debugCanvas2dContext : CanvasRenderingContext2D;

	private var _painter : Painter;

	private var _signal : ISignal2<IComponentRenderManager<E>, ComponentRenderManagerUpdateType>;
	
	private var _highQuality : Bool;

	private var _rootModified : Bool;

	public function new(?highQuality : Bool = false){
		_highQuality = highQuality;
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
		
		_context = CommonJS.newElement("canvas", _document);
		_context.id = "gui-hx";
		_context.className = "gui-hx-canvas";
		
		_document.body.appendChild(_context);

		_canvas2dContext = _context.getContext("2d");

		_debugContext = CommonJS.newElement("canvas", _document);
		_debugContext.id = "gui-hx-debug";
		_debugContext.className = "gui-hx-debug-canvas";

		_debugCanvas2dContext = _debugContext.getContext("2d");

		_painter = new Painter(_canvas2dContext, _debugCanvas2dContext, _highQuality);

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
		
		if(_highQuality) {
			_context.style.width = nw + "px";
			_context.style.height = nh + "px";

			var mw : Int = Std.int(nw * 2);
			var mh : Int = Std.int(nh * 2);

			_canvas2dContext.canvas.width = mw;
			_canvas2dContext.canvas.height = mh;

			_canvas2dContext.scale(2, 2);
			
			_painter.bounds.width = mw;
			_painter.bounds.height = mh;
		} else {
			_canvas2dContext.canvas.width = nw;
			_canvas2dContext.canvas.height = nh;

			_painter.bounds.width = nw;
			_painter.bounds.height = nh;
		}

		if(_painter.debug) {
			_debugCanvas2dContext.canvas.width = nw;
			_debugCanvas2dContext.canvas.height = nh;
		}

		// Grab the iterator and invalidate them if we resize.
		var itr : Iterator<Graphics> = _painter.iterator();
		for(g in itr) {
			g.invalidate();
		}
	}

	public function onContainerUpdate(event : ContainerEvent) : Void {
		switch(event.type) {
			case ContainerEventType.COMPONENT_ADDED:
				_rootModified = true;

				var component : IComponent = event.component;
				if(Std.is(component.view, GraphicsComponentView)) {
					var view : GraphicsComponentView = cast component.view;
					
					// Push the context on to the graphics when we add it.
					view.graphics.context = _canvas2dContext;
				}
		}
	}
	
	private function render() : Void {
		//untyped __js__("stats.begin();");

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

		//untyped __js__ ("stats.end();");
	}

	private function notify(type : ComponentRenderManagerUpdateType) : Void {
		_signal.dispatch(this, type);
	}

	private function get_context() : E {
		return _context;
	}

	private function get_debug() : Bool {
		return _painter.debug;
	}

	private function set_debug(value : Bool) : Bool {
		_painter.debug = !_painter.debug;
		if(_painter.debug) {
			_document.body.appendChild(_debugContext);
		} else {
			_document.body.removeChild(_debugContext);
		}

		resizeTo(_window.innerWidth, _window.innerHeight);
		return _painter.debug;
	}
}
