package funk.gui.js.core.display;

enum Unit {
	em(value : Float);
	percent(value : Float);
	px(value : Float);
}

class UnitType {

	public static function format(unit : Unit) : String {
		return switch(unit) {
			case em(value): value + "em";
			case percent(value): value + "%";
			case px(value): value + "px";
		}
	}
}