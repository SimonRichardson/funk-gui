package funk.gui.core.observables;

import funk.gui.core.Component;
import funk.gui.core.ComponentModel;
import funk.option.Any;

using funk.option.Any;

class ComponentModelObserver implements IComponentModelObserver {
	
	private var _component : IComponent;
	
	public function new(component : IComponent) {
		_component = component;
	}
	
	public function onComponentModelUpdate(componentModel : IComponentModel, type : Int) : Void {
		if(_component.view.isDefined()) 
			_component.view.onComponentModelUpdate(componentModel, type);
	}
	
}
