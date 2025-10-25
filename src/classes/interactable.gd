extends Area3D
class_name Interactable

@export var is_collectible : bool

@export var plante: Plante
#@export var item : InventoryItem

func on_interaction():
	print(self, " : Tu as intéragis avec moi !")
	if is_collectible:
		pick_up()

func pick_up():
	print("Tu m'as récupéré !")
	#print(plante)
	Global.player_inventory.add_item(plante.item)
	if(!Global.herbier.has(plante)):
		Global.herbier.push_back(plante)
	
	#print(plante.type)
	#print(plante.texture)
	#print(plante.description)
	#print(plante.item.type)
	#print(plante.item.texture)
	#print(plante.item.description)
