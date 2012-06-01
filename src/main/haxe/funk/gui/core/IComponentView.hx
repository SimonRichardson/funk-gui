package funk.gui.core;

import funk.gui.core.Component;
import funk.gui.core.IComponentModel;
import funk.gui.core.ComponentState;

interface IComponentView {
	
	var x(dynamic, never) : Float;
	
	var y(dynamic, never) : Float;
	
	var width(dynamic, never) : Float;
	
	var height(dynamic, never) : Float;
	
	function onComponentInitialize(component : IComponent) : Void;
	
	function onComponentMove(x : Float, y : Float) : Void;
	
	function onComponentResize(width : Float, height : Float) : Void;
	
	function onComponentModelUpdate(model : IComponentModel, type : Int) : Void;
	
	function onComponentStateUpdate(state : ComponentState, type : ComponentStateType) : Void;
	
	function onComponentCleanup() : Void;
}
