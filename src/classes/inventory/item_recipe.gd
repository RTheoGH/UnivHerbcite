extends Resource

class_name ItemRecipe

@export var ingredients :  Array[InventoryItem]
@export var result : InventoryItem # Peut-être changer le type (on peut ne plus avoir de place en craftant)

func can_craft(ing : Array[InventoryItem]) -> bool:
	
	if ing.size() == ingredients.size():
		for i in ingredients:
			var i_contained := false
			for j in ing:
				if i.type == j.type:
					i_contained = true
					break
			if !i_contained:
				return false
	else:
		return false
	
	return true
