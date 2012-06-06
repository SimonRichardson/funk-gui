package funk.gui.button;

class Button extends ButtonComponent {
	
	public function new(view : IButtonView) {
		super(view);
	}
	
	override private function initTypes() : Void {
		allowViewType(IButtonView);
		allowModelType(ButtonModel);
	}
}