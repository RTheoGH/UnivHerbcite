extends Control
var grabbed_object: int = -1
var hoverred_object: int = -1
var hoverred_slot: Vector2
@onready var inventory: Inventory = Global.player_inventory
@onready var inventory_objects := [$Object1, $Object2, $Object3]
var objects_slots : Array[Vector2]
@onready var inventory_slots_positions := [$Place1.global_position, $Place2.global_position, $Place3.global_position]
var precedent_place : Vector2 = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# TODO : À changer pour le vrai inventaire
	#var new_item = load("res://inventory/items/Olivier.tres")
	#var new_item2 = load("res://inventory/items/Figue.tres")
	#inventory.items.append(new_item)
	#inventory.items.append(new_item2)
	objects_slots.resize(3)
	
	for i in range(Global.player_inventory.items.size()):
		
		inventory_objects[i].get_node("TextureRect").texture = inventory.items[i].texture
		inventory_objects[i].visible = true
		objects_slots[i] = inventory_slots_positions[i]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if hoverred_object != -1 and Input.is_action_just_pressed("left_click"):
		precedent_place = objects_slots[hoverred_object]
		print("precedent :", precedent_place)
		grabbed_object = hoverred_object

	if grabbed_object != -1:
		
		if Input.is_action_pressed("left_click"):
			inventory_objects[grabbed_object].global_position = get_global_mouse_position()
		
		# Objet relâché
		elif can_place():
			inventory_objects[grabbed_object].global_position = objects_slots[grabbed_object]
			grabbed_object = -1
			
		else:
			print("Pas le droit de placer ici !")
			inventory_objects[grabbed_object].global_position = precedent_place
			objects_slots[grabbed_object] = precedent_place
			
	if Input.is_action_just_released("left_click"):
		grabbed_object = -1
	
	
func can_place() -> bool :
	
	print(objects_slots)
	
	if grabbed_object == -1:
		return false
		
	var count := 0
	var comp := objects_slots[grabbed_object]
	for i in range(objects_slots.size()):
		
		if objects_slots[i] == comp:
			count += 1
		if count > 1:
			return false
			
	return true
	
func refresh() -> void:
	for i in range(Global.player_inventory.items.size()):
		print("azy")
		inventory_objects[i].get_node("TextureRect").texture = Global.player_inventory.items[i].texture
		inventory_objects[i].visible = true
		objects_slots[i] = inventory_slots_positions[i]

func _on_area_2d_mouse_entered() -> void:
	if grabbed_object == -1:
		hoverred_object = 0


func _on_area_2d_mouse_entered_2() -> void:
	if grabbed_object == -1:
		hoverred_object = 1


func _on_area_2d_mouse_entered_3() -> void:
	if grabbed_object == -1:
		hoverred_object = 2


func _on_area_2d_mouse_exited() -> void:
	hoverred_object = -1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if grabbed_object != -1:
		objects_slots[grabbed_object] = body.global_position


func _on_confirm_2_button_up() -> void:
	Global.is_craft_ui_open = false


func _on_visibility_changed() -> void:
	if visible:
		refresh()
