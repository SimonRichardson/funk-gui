package funk.gui.core;

import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentObserver;
import funk.gui.core.ComponentView;
import funk.gui.core.ComponentState;
import funk.gui.core.events.ComponentEvent;
import funk.gui.core.observables.ComponentModelObserver;
import funk.gui.core.observables.ComponentStateObserver;
import funk.errors.AbstractMethodError;
import funk.errors.ArgumentError;
import funk.option.Any;
import funk.signal.Signal1;

using funk.option.Any;

interface IComponent {
	
	var model(dynamic, dynamic) : IComponentModel;
	
	var state(dynamic, dynamic) : ComponentState;
	
	var view(dynamic, dynamic) : IComponentView;
	
	function addComponentObserver(observer : IComponentObserver) : IComponentObserver;
	
	function removeComponentObserver(observer : IComponentObserver) : IComponentObserver;
	
	function moveTo(x : Float, y : Float): Void;
	
	function resizeTo(width : Float, height : Float) : Void;
}

typedef ComponentNamespace = {
	
	var event(dynamic, dynamic) : ComponentEvent;
	
	function initComponent(componentView : IComponentView) : Void;
	
	function dispatchComponentEvent(type : ComponentEventType) : Void;
}

class Component implements IComponent {
	
	public var model(get_model, set_model) : IComponentModel;
	
	public var state(get_state, set_state) : ComponentState;
	
	public var view(get_view, set_view) : IComponentView;
	
	private var event(get_event, set_event) : ComponentEvent;
	
	private var _model : IComponentModel;
	
	private var _state : ComponentState;
	
	private var _view : IComponentView;
	
	private var _signal : ISignal1<ComponentEvent>;
	
	private var _componentEvent : ComponentEvent;
	
	private var _modelObserver : IComponentModelObserver;
	
	private var _stateObserver : IComponentStateObserver;
	
	public function new(componentView : IComponentView) {
		_signal = new Signal1<ComponentEvent>();
		
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
	
	@:final
	private function initComponent(componentView : IComponentView) : Void {
		initModel();
		initState();
		initEvents();
		
		initView(componentView);
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
}
