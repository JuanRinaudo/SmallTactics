package ludumdare38;


class BuildingList 
{
	public var buildings:Array<Building>;

	public function new() 
	{
		buildings = [];
	}
	
	public function addBuilding(building:Building) {
		building.buildingList = this;
		buildings.push(building);
	}
	
	public function removeBuilding(building:Building) {
		building.buildingList = null;
		buildings.remove(building);
	}
	
	public function availableBuildings():Array<Building> {
		var temp:Array<Building> = [];
		for (building in buildings) {
			if (building.canBeUsed) {
				temp.push(building);
			}
		}
		return temp;
	}
	
	public function getBuildingByType(type:BuildingType):Array<Building> {
		var temp:Array<Building> = [];
		for (building in buildings) {
			if (building.type == type) {
				temp.push(building);
			}
		}
		return temp;
	}
	
}