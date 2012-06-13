package funk.gui.button;

class Button extends ButtonComponent {
	
	public function new(view : IButtonView) {
		super(view);
	}
	
	override private function initTypes() : Void {
		allowViewType(IButtonView);
		allowModelType(ButtonModel);
	}
	
	override public function toString() : String {
		return Std.format("[Button (id:$id)]");
	}
}
