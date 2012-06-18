package funk.gui.text;

import funk.gui.core.Component;
import funk.gui.core.IComponentModel;
import funk.gui.core.IComponentModelObserver;
import funk.gui.core.IComponentView;
import funk.gui.core.display.IComponentImageData;
import funk.gui.core.display.ImageData;
import funk.gui.core.events.ComponentEvent;
import funk.option.Any;

using funk.option.Any;

class Label extends Component, implements ITextComponent {
	
	public var text(get_text, set_text) : String;
	
	public var icon(getIcon, setIcon) : ImageData;
	
	private var _labelModel : LabelModel;
	
	private var _labelModelObserver : IComponentModelObserver;
	
	public function new(componentView : IComponentView) {
		super(componentView);
	}
	
	override private function initModel() : Void {
		model = new LabelModel();
	}
	
	override private function initEvents() : Void {
		event = new ComponentEvent(this);
	}
	
	override private function initTypes() : Void {
		allowViewType(ILabelView);
		allowModelType(LabelModel);
	}

	override private function set_model(componentModel : IComponentModel) : IComponentModel {
		return super.set_model(_labelModel = cast componentModel);
	}
	
	private function get_text() : String {
		return _labelModel.text;
	}
	
	private function set_text(value : String) : String {
		_labelModel.text = value;
		return _labelModel.text;
	}
	
	private function getIcon() : ImageData {
		return _labelModel.icon;
	}
	
	private function setIcon(value : ImageData) : ImageData {
		_labelModel.icon = value;
		return _labelModel.icon;
	}
}
