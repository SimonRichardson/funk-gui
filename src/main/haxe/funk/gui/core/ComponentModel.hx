package funk.gui.core;

import funk.gui.core.Container;
import funk.gui.core.ComponentObserver;
import funk.signal.Signal2;

interface IComponentModel {
	
	var id(dynamic, dynamic) : Int;
	
	var parent(dynamic, dynamic) : IContainer;
	
	var editMode(dynamic, dynamic) : Bool;
	
	function addComponentModelObserver(observer : IComponentModelObserver) : Void;
	
	function removeComponentModelObserver(observer : IComponentModelObserver) : Void;
}

interface IComponentModelObserver {
	
	function onComponentModelUpdate(model : IComponentModel, type : Int) : Void;
}

typedef ComponentModelNamespace = {
	function notify(type : Int) : Void;
}

class ComponentModel implements IComponentModel {
	
	inline public static var UPDATE_ALL_VALUES : Int = -1;
	
	public var id(get_id, set_id) : Int;
	
	public var parent(get_parent, set_parent) : IContainer;
	
	public var editMode(get_editMode, set_editMode) : Bool;
	
	private var _signal : ISignal2<IComponentModel, Int>;
	
	private var _id : Int;
	
	private var _parent : IContainer;
	
	private var _editMode : Bool;
	
	private var _dirty : Bool;
	
	public function new() {
		_signal = new Signal2<IComponentModel, Int>();
		
		_editMode = false;
		_dirty = false;
	}
	
	public function addComponentModelObserver(observer : IComponentModelObserver) : Void {
		_signal.add(observer.onComponentModelUpdate);
	}
	
	public function removeComponentModelObserver(observer : IComponentModelObserver) : Void {
		_signal.remove(observer.onComponentModelUpdate);
	}
	
	private function notify(type : Int) : Void {
		if(!_editMode) {
			_signal.dispatch(this, type);
			_dirty = false;
		} else  {
			_dirty = true;
		}
	}
	
	private function get_id() : Int {
		return _id;
	}
	
	private function set_id(value : Int) : Int {
		return _id = value;
	}
	
	private function get_parent() : IContainer {
		return _parent;
	}
	
	private function set_parent(value : IContainer) : IContainer {
		return _parent = value;
	}
	
	private function get_editMode() : Bool {
		return _editMode;
	}
	
	private function set_editMode(value : Bool) : Bool {
		if(value != _editMode) {
			_editMode = value;
			if(!_editMode && _dirty) {
				notify(UPDATE_ALL_VALUES);
			}
		}
		return _editMode;
	}
}
