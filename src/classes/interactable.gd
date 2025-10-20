extends Area3D
class_name Interactable

@export var is_collectible : bool

@export var item : InventoryItem

func on_interaction():
	print(self, " : Tu as intéragis avec moi !")
	if is_collectible:
		pick_up()

func pick_up():
	print("Tu m'as récupéré !")
	Global.player_inventory.add_item(item)
