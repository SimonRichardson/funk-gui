package funk.gui.text;

import funk.gui.core.IComponent;

interface ITextComponent implements IComponent {

	var text(dynamic, dynamic) : String;
}