package funk.gui.core;

interface IComponentModel {
	
	var id(dynamic, dynamic) : Int;
	
	var parent(dynamic, dynamic) : IContainer;
	
	var editMode(dynamic, dynamic) : Bool;
	
	function addComponentModelObserver(observer : IComponentModelObserver) : Void;
	
	function removeComponentModelObserver(observer : IComponentModelObserver) : Void;
}