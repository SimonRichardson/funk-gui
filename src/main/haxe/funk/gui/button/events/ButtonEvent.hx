package funk.gui.button.events;

import funk.gui.button.ButtonComponent;
import funk.gui.core.display.IComponentImageData;
import funk.gui.core.events.ComponentEvent;

class ButtonEventType extends ComponentEventType {
	
	public static var DESELECT : ButtonEventType = new ButtonEventType();
	
	public static var SELECT : ButtonEventType = new ButtonEventType();

	public static var TRIGGER : ButtonEventType = new ButtonEventType();

	private function new(){
		super();
	}
}

class ButtonEvent extends ComponentEvent {

	public var text(getText, never) : String;
	
	public var icon(getIcon, never) : IComponentImageData;

	public var selected(getSelected, never) : Bool;

	private var _buttonComponent : ButtonComponent;

	public function new(buttonComponent : ButtonComponent) {
		super(_buttonComponent = buttonComponent);
	}
	
	private function getText() : String {
		return _buttonComponent.text;
	}

	private function getIcon() : IComponentImageData {
		return _buttonComponent.icon;
	}
	
	private function getSelected() : Bool {
		return _buttonComponent.selected;
	}
}
