package funk.gui.core.events;

interface IEvent {

	function add(func : Void -> Void, ?once : Bool = false) : Void;

	function remove(func : Void -> Void) : Void;
}