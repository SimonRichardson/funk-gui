package funk.gui.core;

import funk.gui.core.IComponentModel;

interface IComponentModelObserver {
	
	function onComponentModelUpdate(model : IComponentModel, type : Int) : Void;
}