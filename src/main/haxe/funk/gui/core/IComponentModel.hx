package funk.gui.core;

import funk.gui.core.events.IComponentEventTarget;

interface IComponentModel {
	
	var id(dynamic, dynamic) : Int;
	
	var parent(dynamic, dynamic) : IContainer;

	var eventParent(dynamic, dynamic) : IComponentEventTarget;
	
	var editMode(dynamic, dynamic) : Bool;
	
	function addComponentModelObserver(observer : IComponentModelObserver) : Void;
	
	function removeComponentModelObserver(observer : IComponentModelObserver) : Void;
}