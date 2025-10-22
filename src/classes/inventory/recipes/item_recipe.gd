extends Resource

class_name ItemRecipe

@export var ingredient1 : InventoryItem
@export var ingredient2 : InventoryItem
@export var ingredient3 : InventoryItem
@export var result : InventoryItem # Peut-être changer le type (on peut ne plus avoir de place en craftant)

func can_craft(ing : Array[InventoryItem]) -> bool:
	
	return ingredient1 == ing[0] && ingredient2 == ing[1] && ingredient3 == ing[2]
