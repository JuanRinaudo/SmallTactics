package ludumdare38;
import kge.core.Basic;
import kge.core.Group;


class UnitList
{
	public var units:Array<Unit>;
	
	public function new() 
	{
		units = [];
	}
	
	public function addUnit(unit:Unit) {
		unit.unitList = this;
		units.push(unit);
	}
	
	public function removeUnit(unit:Unit) {
		unit.unitList = null;
		units.remove(unit);
	}
	
	public function availableUnits():Array<Unit> {
		var temp:Array<Unit> = [];
		for (unit in units) {
			if (unit.canDoAction || unit.canMove) {
				temp.push(unit);
			}
		}
		return temp;
	}
	
	public function refreshAllUnits() {
		for (unit in units) {
			unit.canMove = true;
			unit.canDoAction = true;
		}
	}
	
}