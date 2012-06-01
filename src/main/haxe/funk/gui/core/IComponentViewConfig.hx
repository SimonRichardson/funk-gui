package funk.gui.core;

import funk.gui.core.geom.LayoutSize;
import funk.gui.core.geom.Size;
import funk.gui.core.geom.TRBL;

interface IComponentViewConfig {
	
	var size(dynamic, dynamic) : LayoutSize;
	
	var padding(dynamic, dynamic) : TRBL;
	
	var margin(dynamic, dynamic) : TRBL;
}