package;

import All;
import funk.gui.button.Button;
import gui.js.ButtonView;

class Main {
	
	public function new(){
		var view = new ButtonView();
		var button = new Button(view);
	}
	
	public static function main() : Void {
		new Main();
	}
}