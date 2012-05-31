package funk.gui.core;

import funk.gui.core.Container;
import funk.gui.core.ComponentObserver;

interface IComponentModel {
	
	var id(dynamic, dynamic) : Int;
	
	var parent(dynamic, dynamic) : IContainer;
	
	function addComponentModelObserver(observer : IComponentModelObserver) : Void;
	
	function removeComponentModelObserver(observer : IComponentModelObserver) : Void;
}

interface IComponentModelObserver {
	
	function onComponentModelUpdate(model : IComponentModel, type : Int) : Void;
}

class ComponentModel implements IComponentModel {
	
	inline public static var UPDATE_ALL_VALUES : Int = -1;
	
}
