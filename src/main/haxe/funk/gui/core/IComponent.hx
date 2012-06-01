package funk.gui.core;

import funk.gui.core.ComponentModel;
import funk.gui.core.ComponentState;
import funk.gui.core.IComponentObserver;
import funk.gui.core.IComponentView;

interface IComponent {
	
	var model(dynamic, dynamic) : IComponentModel;
	
	var view(dynamic, dynamic) : IComponentView;
	
	var state(dynamic, dynamic) : ComponentState;
	
	function addComponentObserver(observer : IComponentObserver) : IComponentObserver;
	
	function removeComponentObserver(observer : IComponentObserver) : IComponentObserver;
	
	function moveTo(x : Float, y : Float): Void;
	
	function resizeTo(width : Float, height : Float) : Void;
}
