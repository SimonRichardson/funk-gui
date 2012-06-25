package funk.gui.js.core.event;

import funk.gui.core.events.IEvent;
import funk.gui.core.events.AbstractEvent;

import haxe.Timer;

import js.Dom;
import js.w3c.html5.Core;

class Events {

	public static var render : IEvent = new RenderEvent();
}

class RenderEvent extends AbstractEvent, implements IEvent {

	inline private static var RENDER_TIME_STEP : Int = Std.int(1000 / 20);

	inline private static var POST_RENDER_TIME_STEP : Int = 1;

	private var _window : Window;

	private var _invalidated : Bool;

	private var _requestAnimationFrame : Dynamic;

	public function new() {
		super();

		_window = untyped __js__("window");

		_invalidated = false;

		_requestAnimationFrame = Reflect.field(_window, 'requestAnimationFrame') || 
								 Reflect.field(_window, 'mozRequestAnimationFrame') ||
								 Reflect.field(_window, 'webkitRequestAnimationFrame') ||
								 Reflect.field(_window, 'msRequestAnimationFrame');
		
		if(_requestAnimationFrame == null) {
			_requestAnimationFrame = function(c : (Void -> Void)) : Void {
				Timer.delay(function() : Void {
					render();
				}, RENDER_TIME_STEP);
			};
		}
	}

	override public function add(func : Void -> Void, ?once : Bool = false) : Void {
		super.add(func, once);

		if(!_invalidated) {
			_invalidated = true;

			request();
		}
	}

	private function render() : Void {
		notify();

		if(size > 0) {
			request();
		} else {
			_invalidated = false;
		}
	}

	private function request() : Void {
		// This shouldn't be possible, without the use of Reflect!
		_requestAnimationFrame.call(_window, render);
	}
}