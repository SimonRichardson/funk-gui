package funk.gui.button;

class ToggleButton extends ButtonComponent {
	
	public function new(view : IToggleButtonView) {
		super(view);
	}
	
	override private function initTypes() : Void {
		allowViewType(IToggleButtonView);
		allowModelType(ButtonModel);
	}

	override public function toString() : String {
		return "[ToggleButton]";
	}
}
