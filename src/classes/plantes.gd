extends Resource

class_name Plante

enum PlanteType{
	JUJUBIER,
	ARBOUSIER, 
	ASPERGES,
	MYROBOLAN,
	OLIVIER,
	FIGUIER,
	LAVANDES,
	LIERRES,
	ACANTHES,
	
	DEBUG
}

@export var type : PlanteType
@export var texture : Texture2D
@export var description : String = ""
@export var item : InventoryItem
