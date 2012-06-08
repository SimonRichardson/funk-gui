package funk.gui;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.option.Any;
import funk.option.Option;
import funk.gui.core.display.IComponentRenderManager;
import funk.gui.core.events.IComponentEventManager;
import funk.gui.core.IComponent;
import funk.gui.core.IComponentRoot;

using funk.collections.immutable.Nil;
using funk.option.Any;

class Root<T> implements IComponentRoot<T> {
	
	public var size(get_size, never) : Int;
	
	public var root(get_root, never) : IComponentRoot<T>;
	
	public var eventManager(default, setEventManager) : IComponentEventManager<T>;
	
	public var renderManager(default, setRenderManager) : IComponentRenderManager<T>;
	
	private var _list : IList<IComponent>;
	
	public function new() {
		_list = nil.list();
	}
	
	public function add(component : IComponent) : IComponent {
		_list = _list.prepend(component);
		invalidate();
		return component;
	}

	public function addAt(component : IComponent, index : Int) : IComponent {
		if(index == 0) {
			_list = _list.append(component);	
		} else if(index == size) {
			_list = _list.prepend(component);
		} else {
			var p = 0;
			_list = _list.flatMap(function(c) : IList<IComponent> {
				var l = nil.list();
				l = l.prepend(c);
				if(p == index) {
					l = l.prepend(component);
				}
				p++;
				return l;
			});
		}
		invalidate();
		return component;
	}

	public function remove(component : IComponent) : IComponent {
		_list = _list.filter(function(c) : Bool {
			return c == component;
		});
		invalidate();
		return component;
	}

	public function removeAt(index : Int) : Option<IComponent> {
		var p = 0;
		var o = None;
		_list = _list.filter(function(c) : Bool {
			var result = p == index;
			if(result) {
				o = Some(c);
			}
			p++;
			return result;
		});
		invalidate();
		return o;
	}

	public function getAt(index : Int) : IComponent {
		return switch(_list.get(index)) {
			case Some(x): x;
			case None: null;
		}
	}

	public function contains(component : IComponent) : Bool {
		return _list.contains(component);
	}

	public function getIndex(component : IComponent) : Int {
		return _list.indexOf(component);
	}
	
	public function invalidate() : Void {
		renderManager.invalidate();
	}

	public function iterator() : Iterator<IComponent> {
		return _list.iterator();
	}
	
	private function get_size() : Int {
		return _list.size;
	}
	
	private function get_root() : IComponentRoot<T> {
		return this;
	}
	
	private function setEventManager(value : IComponentEventManager<T>) : IComponentEventManager<T> {
		if(eventManager.isDefined()) {
			eventManager.onEventManagerCleanup();
			eventManager = null;
		}
		
		if(value != eventManager) {
			eventManager = value;
			eventManager.onEventManagerInitialize(this);
		}
		return eventManager;
	}
	
	private function setRenderManager(value : IComponentRenderManager<T>) : IComponentRenderManager<T> {
		if(renderManager.isDefined()) {
			renderManager.onRenderManagerCleanup();
			renderManager = null;
		}
		
		if(value != renderManager) {
			renderManager = value;
			renderManager.onRenderManagerInitialize(this);
		}
		return renderManager;
	}
}
