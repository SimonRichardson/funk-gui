package funk.gui.core;

import funk.gui.core.Component;

interface IContainer implements IComponent {
	
	var numComponents(dynamic, never) : Int;
		
	function addComponent(component : IComponent) : IComponent;

	function addComponentAt(component : IComponent, index : Int) : IComponent;

	function removeComponent(component : IComponent) : IComponent;

	function removeComponentAt(index : Int) : IComponent;

	function getComponentAt(index : Int) : IComponent;

	function containsComponent(component : IComponent) : Bool;

	function getComponentIndex(component : IComponent) : Int;
}
