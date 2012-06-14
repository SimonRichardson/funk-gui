package funk.gui.core;

import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.gui.core.IComponentModelObserver;
import funk.gui.core.IComponentObserver;
import funk.gui.core.IComponentView;
import funk.gui.core.events.ComponentEvent;
import funk.gui.core.events.IComponentEventTarget;
import funk.gui.core.events.UIEvent;
import funk.gui.core.geom.Point;
import funk.gui.core.observables.ComponentModelObserver;
import funk.gui.core.observables.ComponentStateObserver;
import funk.errors.AbstractMethodError;
import funk.errors.ArgumentError;
import funk.option.Any;
import funk.signal.Signal1;
import funk.errors.IllegalOperationError;

using funk.option.Any;

typedef ComponentDispatchEventNamespace = {
	
	function dispatchComponentEvent(type : ComponentEventType) : Void;	
}

class Component implements IComponent {
	
	public var id(get_id, set_id) : Int;
	
	public var parent(get_parent, set_parent) : IContainer;
	
	public var model(get_model, set_model) : IComponentModel;
	
	public var state(get_state, set_state) : ComponentState;
	
	public var view(get_view, set_view) : IComponentView;
	
	public var pressed(get_pressed, set_pressed) : Bool;
	
	public var hovered(get_hovered, set_hovered) : Bool;
	
	public var focused(get_focused, set_focused) : Bool;
	
	public var enabled(get_enabled, set_enabled) : Bool;
	
	public var eventParent(get_eventParent, never) : IComponentEventTarget;

	private var event(get_event, set_event) : ComponentEvent;
	
	private var _model : IComponentModel;
	
	private var _state : ComponentState;
	
	private var _view : IComponentView;
	
	private var _modelType : Class<IComponentModel>;
	
	private var _stateType : Class<ComponentState>;
	
	private var _viewType : Class<IComponentView>;
	
	private var _signal : ISignal1<ComponentEvent>;
	
	private var _componentEvent : ComponentEvent;
	
	private var _modelObserver : IComponentModelObserver;
	
	private var _stateObserver : IComponentStateObserver;
	
	public function new(componentView : IComponentView) {
		_signal = new Signal1<ComponentEvent>();
		_stateType = ComponentState;
		
		initComponent(componentView);
	}
	
	public function addComponentObserver(observer : IComponentObserver) : IComponentObserver {
		_signal.add(observer.onComponentEvent);
		return observer;
	}
	
	public function removeComponentObserver(observer : IComponentObserver) : IComponentObserver {
		_signal.remove(observer.onComponentEvent);
		return observer;
	}
	
	public function moveTo(x : Float, y : Float): Void {
		if(view.isDefined()) {
			if(view.x == x && view.y == y) {
				return;
			}
			
			view.onComponentMove(x, y);
		}
	}
	
	public function resizeTo(width : Float, height : Float) : Void {
		if(width < 0) width = 0;
		if(height < 0) height = 0;
		
		if(view.isDefined()) {
			if(view.width == width && view.height == height) {
				return;
			}
			
			view.onComponentResize(width, height);
		}
	}

	public function captureEventTarget(point : Point) : IComponentEventTarget {
		if(view.isDefined()) {
			if(view.containsPoint(point)) {
				return this;
			}
		}
		return null;
	}

	public function processEvent(event : UIEvent) : Void {
		if(!enabled) return;
		else {
			switch(event.type) {
				case FOCUS_OUT: focused = false;
				case FOCUS_IN(focusOut, focusIn): focused = focusIn == this;
				case MOUSE_IN(position): hovered = true;
				case MOUSE_DOWN(position): pressed = true;
				case MOUSE_MOVE(position, downPosition): 
				case MOUSE_UP(position): pressed = false;
				case MOUSE_OUT(position): hovered = false;
				default:
			}
		}
	}
	
	private function initComponent(componentView : IComponentView) : Void {
		initTypes();
		
		if(_viewType.isEmpty()) throw new IllegalOperationError("View type can not be null");
		if(_modelType.isEmpty()) throw new IllegalOperationError("Model type can not be null");
		if(_stateType.isEmpty()) throw new IllegalOperationError("State type can not be null");
		
		initModel();
		initState();
		initEvents();
		
		initView(componentView);
	}
	
	private function initTypes() : Void {
		throw new AbstractMethodError("initTypes");
	}
	
	private function initModel() : Void {
		throw new AbstractMethodError("initModel");
	}
	
	private function initState() : Void {
		state = new ComponentState();
	}
	
	private function initEvents() : Void {
		throw new AbstractMethodError("initEvents");
	}
	
	private function initView(componentView : IComponentView) : Void {
		view = componentView.getOrElse(function() : IComponentView {
			throw new ArgumentError("Trying to initialize component with a null view.");
			return null;
		});
	}
	
	@:final 
	private function allowModelType(value : Class<IComponentModel>) : Void {
		_modelType = value;
	}
	
	@:final 
	private function allowStateType(value : Class<ComponentState>) : Void {
		_stateType = value;
	}
	
	@:final 
	private function allowViewType(value : Class<IComponentView>) : Void {
		_viewType = value;
	}
	
	private function dispatchComponentEvent(type : ComponentEventType) : Void {
		_componentEvent.reset(type);
		_signal.dispatch(_componentEvent);
	}
	
	private function get_event() : ComponentEvent {
		return _componentEvent;
	}
	
	private function set_event(componentEvent : ComponentEvent) : ComponentEvent {
		if(componentEvent != _componentEvent) _componentEvent = componentEvent;
		return componentEvent;
	}
	
	private function get_model() : IComponentModel {
		return _model;
	}
	
	private function set_model(componentModel : IComponentModel) : IComponentModel {
		if(_model == componentModel) return componentModel;
		
		if(_model.isDefined()) {
			_model.removeComponentModelObserver(_modelObserver);
			_modelObserver = null;
		}
		
		if(componentModel.isDefined()) {
			_model = componentModel;
			_modelObserver = new ComponentModelObserver(this);
			_model.addComponentModelObserver(_modelObserver);
			
			if(view.isDefined()) view.onComponentModelUpdate(model, ComponentModel.UPDATE_ALL_VALUES);
			
		} else {
			if(_model.isDefined()) {
				_model = null;
			}
		}
		
		return componentModel;
	}
	
	private function get_view() : IComponentView {
		return _view;
	}
	
	private function set_view(componentView : IComponentView) : IComponentView {
		if(_view == componentView) return componentView;
		
		if(_view.isDefined()) _view.onComponentCleanup();
		
		if(componentView.isDefined()) {
			_view = componentView;
			_view.onComponentInitialize(this);
			
			if(model.isDefined()) _view.onComponentModelUpdate(model, ComponentModel.UPDATE_ALL_VALUES);
			if(state.isDefined()) _view.onComponentStateUpdate(state, ComponentStateType.UPDATE_ALL_VALUES);
			
		} else {
			if(_view.isDefined()) {
				_view = null;
			}
		}
		
		return componentView;
	}
	
	private function get_state() : ComponentState {
		return _state;
	}
	
	private function set_state(componentState : ComponentState) : ComponentState {
		if(_state == componentState) return _state;
		
		if(_state.isDefined()) {
			_state.removeComponentStateObserver(_stateObserver);
			_stateObserver = null;
		}
		
		if(componentState.isDefined()) {
			_state = componentState;
			_stateObserver = new ComponentStateObserver(this);
			_state.addComponentStateObserver(_stateObserver);
			
			if(view.isDefined()) view.onComponentStateUpdate(state, ComponentStateType.UPDATE_ALL_VALUES);
			
		} else {
			if(_state.isDefined()) {
				_state = null;
			}
		}
		
		return componentState;
	}
	
	private function get_id() : Int {
		return model.id;
	}
	
	private function set_id(value : Int) : Int {
		return model.id = value;
	}
	
	private function get_parent() : IContainer {
		return model.parent;
	}
	
	private function set_parent(value : IContainer) : IContainer {
		return model.parent = value;
	}
	
	private function get_pressed() : Bool {
		return state.pressed;
	}
	
	private function set_pressed(value : Bool) : Bool {
		return state.pressed = value;
	}
	
	private function get_hovered() : Bool {
		return state.hovered;
	}
	
	private function set_hovered(value : Bool) : Bool {
		return state.hovered = value;
	}
	
	private function get_focused() : Bool {
		return state.focused;
	}
	
	private function set_focused(value : Bool) : Bool {
		return state.focused = value;
	}
	
	private function get_enabled() : Bool {
		return state.enabled;
	}
	
	private function set_enabled(value : Bool) : Bool {
		return state.enabled = value;
	}

	private function get_eventParent() : IComponentEventTarget {
		return model.parent;
	}

	public function toString() : String {
		return "[Component]";
	}
}
