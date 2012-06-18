package funk.gui.core.display;

import funk.gui.core.IComponent;
import funk.gui.core.display.ImageData;

interface IComponentImageData {

	var enabled(dynamic, never) : ImageData;

	var hovered(dynamic, never) : ImageData;

	var pressed(dynamic, never) : ImageData;

	var disabled(dynamic, never) : ImageData;

	var focused(dynamic, never) : ImageData;

	function getIconForState(component : IComponent) : ImageData;
}
