package;

import funk.gui.button.Button;
import funk.gui.button.ToggleButton;
import funk.gui.Root;
import funk.gui.core.IComponentRoot;
import funk.gui.js.core.display.RenderManager;
import funk.gui.js.core.event.EventManager;
import funk.gui.js.display.ButtonView;
import funk.gui.js.display.ToggleButtonView;

import js.w3c.html5.Core;

class Main {
	
	private var _root : Root<HTMLCanvasElement>;

	public function new(){
		
		_root = new Root<HTMLCanvasElement>();
		_root.renderManager = new RenderManager<HTMLCanvasElement>();
		_root.eventManager = new EventManager<HTMLCanvasElement>();
		
		var id : Int = 0;
		for(i in 0...50) {
			for(j in 0...50) {
				var button = new Button(new ButtonView(id));
				button.id = id;
				button.moveTo(j * 31, i * 31);
				button.resizeTo(30, 30);
				_root.add(button);

				id++;
			}
		}

		// This is pure dirt!
		untyped __js__("
			var self = this;
			window.app = {
				debug: function(value) {
					return self.debug(value);
				},
				root: function() {
					return self._root;
				}
			};");
	}

	public function debug(value : Bool) : String {
		_root.debug = value;
		return value ? "Welcome to app debug mode" : "Bye Bye";
	}
	
	public static function main() : Void {
		new Main();
	}
}