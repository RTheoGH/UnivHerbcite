extends Area3D
class_name Interactable

@export var is_collectible : bool

@export var plante: Plante
var cooldown
#@export var item : InventoryItem

func _ready() -> void:
	cooldown = get_tree().create_timer(0)

func on_interaction():
	print(self, " : Tu as intéragis avec moi !")
	if is_collectible:
		pick_up()

func pick_up():
	if cooldown.time_left > 0:
		print("Temps restant : ", cooldown.time_left)
		Global.text_alert.on_cooldonw_left(cooldown.time_left)
		return
		
	print("Tu m'as récupéré !")
	#print(plante)
	Global.player_inventory.add_item(plante.item)
	if(!Global.discoveries.has(plante)):
		Global.discoveries.push_back(plante)
	
	cooldown = get_tree().create_timer(15)
	#print(plante.type)
	#print(plante.texture)
	#print(plante.description)
	#print(plante.item.type)
	#print(plante.item.texture)
	#print(plante.item.description)
