package funk.gui.core.events;

import funk.signal.Signal0;

class AbstractEvent {

	public var size(get_size, never) : Int;

	private var _signal : ISignal0;

	public function new() {
		_signal = new Signal0();
	}

	public function add(func : Void -> Void, ?once : Bool = false) : Void {
		switch(once) {
			case false: _signal.add(func);
			case true: _signal.addOnce(func);
		}
	}

	public function remove(func : Void -> Void) : Void {
		_signal.remove(func);
	}

	private function notify() : Void {
		_signal.dispatch();
	}

	private function get_size() : Int {
		return _signal.size;
	}
}