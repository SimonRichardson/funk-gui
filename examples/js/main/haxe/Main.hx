package;

import funk.gui.button.Button;
import funk.gui.button.ToggleButton;
import funk.gui.Root;
import funk.gui.js.core.display.RenderManager;
import funk.gui.js.core.event.EventManager;
import funk.gui.js.display.ButtonView;
import funk.gui.js.display.ToggleButtonView;

import js.w3c.html5.Core;

class Main {
	
	public function new(){
		
		var root = new Root<HTMLCanvasElement>();
		root.renderManager = new RenderManager<HTMLCanvasElement>();
		root.eventManager = new EventManager<HTMLCanvasElement>();
		
		var id : Int = 0;
		for(i in 0...35) {
			for(j in 0...35) {
				var button = new Button(new ButtonView(id));
				button.id = id;
				button.moveTo(j * 31, i * 31);
				button.resizeTo(30, 30);
				root.add(button);

				id++;
			}
		}

		/*var button = new Button(new ButtonView());
		button.moveTo(10, 20);
		button.resizeTo(100, 50);
		root.add(button);
		
		var toggle = new ToggleButton(new ToggleButtonView());
		toggle.selected = true;
		toggle.moveTo(80, 40);
		toggle.resizeTo(100, 50);
		root.add(toggle);*/
	}
	
	public static function main() : Void {
		new Main();
	}
}