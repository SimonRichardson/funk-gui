package funk.gui.core;

import funk.option.Option;

interface IContainer {
	
	var size(dynamic, never) : Int;
		
	function add(component : IComponent) : IComponent;

	function addAt(component : IComponent, index : Int) : IComponent;

	function remove(component : IComponent) : IComponent;

	function removeAt(index : Int) : Option<IComponent>;

	function getAt(index : Int) : IComponent;

	function contains(component : IComponent) : Bool;

	function getIndex(component : IComponent) : Int;
}
