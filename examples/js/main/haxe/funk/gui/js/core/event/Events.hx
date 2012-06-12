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

	inline private static var RENDER_TIME_STEP : Int = 100;

	inline private static var POST_RENDER_TIME_STEP : Int = 50;

	private var _window : Window;

	private var _requesting : Bool;

	private var _invalidated : Bool;

	private var _requestAnimationFrame : Dynamic;

	public function new() {
		super();

		_window = untyped __js__("window");

		_requesting = false;
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

			// This shouldn't be possible, without the use of Reflect!
			_requestAnimationFrame.call(_window, render);
		} else {
			_requesting = true;
		}
	}

	private function render() : Void {
		notify();

		Timer.delay(function() : Void {
			if(_requesting) {
				_requestAnimationFrame.call(_window, render);
			}

			_requesting = false;
			_invalidated = false;
		}, POST_RENDER_TIME_STEP);
	}
}