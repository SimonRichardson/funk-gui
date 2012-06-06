package;

import All;
import funk.gui.button.Button;
import funk.gui.button.ToggleButton;
import funk.gui.Root;

import gui.js.core.display.RenderManager;
import gui.js.core.event.EventManager;
import gui.js.display.ButtonView;
import gui.js.display.ToggleButtonView;

class Main {
	
	public function new(){
		
		var root = new Root();
		root.renderManager = new RenderManager();
		root.eventManager = new EventManager();
		
		var button = new Button(new ButtonView());
		root.add(button);
		
		var toggle = new ToggleButton(new ToggleButtonView());
		toggle.selected = true;
		root.add(toggle);
	}
	
	public static function main() : Void {
		new Main();
	}
}