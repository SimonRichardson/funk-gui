package funk.gui.core;

import funk.gui.core.Component;

interface IContainer implements IComponent {
	
	var size(dynamic, never) : Int;
		
	function add(component : IComponent) : IComponent;

	function addAt(component : IComponent, index : Int) : IComponent;

	function remove(component : IComponent) : IComponent;

	function removeAt(index : Int) : IComponent;

	function getAt(index : Int) : IComponent;

	function contains(component : IComponent) : Bool;

	function getIndex(component : IComponent) : Int;
}
