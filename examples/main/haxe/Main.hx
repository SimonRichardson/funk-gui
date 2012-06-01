package;

import All;
import funk.gui.button.Button;
import gui.js.ButtonView;

class Main {
	
	public function new(){
		var button = new Button(new ButtonView());
		button.selected = true;
	}
	
	public static function main() : Void {
		new Main();
	}
}