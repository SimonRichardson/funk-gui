package funk.gui.core.events;

interface IEvent {

	var size(dynamic, never) : Int;

	function add(func : Void -> Void, ?once : Bool = false) : Void;

	function remove(func : Void -> Void) : Void;
}