package;

import All;
import funk.gui.button.Button;
import funk.gui.button.ToggleButton;
import gui.js.ButtonView;
import gui.js.ToggleButtonView;

class Main {
	
	public function new(){
		var button = new Button(new ButtonView());
		button.selected = true;
		
		var button = new ToggleButton(new ToggleButtonView());
		button.selected = true;
	}
	
	public static function main() : Void {
		new Main();
	}
}