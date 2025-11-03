extends Area3D
class_name Interactable

@export var is_collectible : bool

@export var plante: Plante
var cooldown

signal on_interaction_signal

func _ready() -> void:
	cooldown = get_tree().create_timer(0)

func on_interaction():
	print(self, " : Tu as intéragis avec moi !")
	on_interaction_signal.emit()
	if is_collectible:
		pick_up()

func pick_up():
	if cooldown.time_left > 0:
		print("Temps restant : ", cooldown.time_left)
		Global.text_alert.on_cooldonw_left(cooldown.time_left)
		return
		
	print("Tu m'as récupéré !")

	Global.player_inventory.add_item(plante.item)
	#if(!Global.discoveries.has(plante)):
		#Global.discoveries.push_back(plante)
	
	cooldown = get_tree().create_timer(15)
