package funk.gui.core;

import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.gui.core.IComponentObserver;
import funk.gui.core.IComponentView;
import funk.gui.core.events.IComponentEventTarget;

interface IComponent implements IComponentEventTarget {
	
	var id(dynamic, dynamic) : Int;
	
	var parent(dynamic, dynamic) : IContainer;
	
	var model(dynamic, dynamic) : IComponentModel;
	
	var view(dynamic, dynamic) : IComponentView;
	
	var state(dynamic, dynamic) : ComponentState;
	
	var pressed(dynamic, dynamic) : Bool;
	
	var hovered(dynamic, dynamic) : Bool;
	
	var focused(dynamic, dynamic) : Bool;
	
	var enabled(dynamic, dynamic) : Bool;
	
	function addComponentObserver(observer : IComponentObserver) : IComponentObserver;
	
	function removeComponentObserver(observer : IComponentObserver) : IComponentObserver;
	
	function moveTo(x : Float, y : Float): Void;
	
	function resizeTo(width : Float, height : Float) : Void;
}
