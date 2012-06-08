package funk.gui.core.events;

import funk.signal.Signal0;

class AbstractEvent {

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
}