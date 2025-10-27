extends Interactable

class_name Chest

signal chest_opened(inv : Inventory)
var chest_inventory : Inventory

func _ready() -> void:
	chest_inventory = Inventory.new()
	chest_inventory.invSize = 10
	chest_inventory.stackSize = 16

func on_interaction():
	Global.is_chest_open = true
	chest_opened.emit(chest_inventory)


func _on_chest_ui_chest_closed(chest_inv: Inventory) -> void:
	chest_inventory = chest_inv
