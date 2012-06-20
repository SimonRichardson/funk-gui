package;

import funk.collections.immutable.ListUtil;
import funk.Pass;
import funk.gui.button.Button;
import funk.gui.button.ToggleButton;
import funk.gui.text.Label;
import funk.gui.Root;
import funk.gui.core.IComponentRoot;
import funk.gui.js.core.display.RenderManager;
import funk.gui.js.core.event.EventManager;
import funk.gui.js.display.ButtonView;
import funk.gui.js.display.LabelView;

import js.w3c.html5.Core;

using funk.collections.immutable.ListUtil;

class Main {
	
	private var _root : Root<HTMLCanvasElement>;

	public function new(){
		
		_root = new Root<HTMLCanvasElement>();
		_root.renderManager = new RenderManager<HTMLCanvasElement>();
		_root.eventManager = new EventManager<HTMLCanvasElement>();

		var size : Int = 40;

		var c = 0;
		for(i in 0...40) {
			for(j in 0...40) {
				var button = new Button(new ButtonView());
				button.moveTo(j * (size + 1), i * (size + 1));
				button.resizeTo(size, size);
				button.text = Std.string(c++);
				_root.add(button);
			}
		}

		debug(true);
		
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