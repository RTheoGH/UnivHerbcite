extends Interactable

class_name Chest

signal chest_opened(inv : Inventory)
var chest_inventory : Inventory

func on_interaction():
	Global.is_chest_open = true
	chest_opened.emit(chest_inventory)
