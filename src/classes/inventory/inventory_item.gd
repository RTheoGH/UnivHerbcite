extends Resource

class_name InventoryItem

enum InventoryItemType{
	JUJUBES,
	ARBOUSES, 
	ASPERGES,
	MYROBOLANS,
	OLIVES,
	FIGUES,
	LAVANDE,
	LIERRES,
	ACANTHES,
	
	POTION_ROUGE,
	POTION_BLEUE,
	POTION_VERTE,
	POTION_VIOLETTE,
	POTION_JAUNE
}

@export var type : InventoryItemType
@export var quantity : int = 1
@export var texture : Texture2D # or texture
@export var tags : Array[String] #if tags are specific things create a class and replace String with Tags class
@export var description : String = "" # Optional


func copy() -> InventoryItem:
	var new_item = InventoryItem.new()
	new_item.type = self.type
	new_item.quantity = self.quantity
	new_item.texture = self.texture
	new_item.tags = self.tags
	new_item.description = self.description
	return new_item
