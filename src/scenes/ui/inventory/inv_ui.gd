extends Control


@onready var slots : Array = $PanelContainer/MarginContainer/HBoxContainer.get_children()
@onready var droppables := get_tree().get_nodes_in_group("droppable")
@onready var draggables := get_tree().get_nodes_in_group("draggable")
@onready var inventory := Global.player_inventory

var is_open = false
var grabbed_object := -1
var hoverred_object := -1
var precedent_place := -1 # pour droppables
var objects_slots : Array[int] = [-1, -1, -1] # map qui associe un draggable à l'indice d'un droppable (0, 1, 2, 3)

func _ready():
	#var inv_item := InventoryItem.new()
	#inv_item.quantity = 3
	#inv_item.texture = load("res://assets/graphical/items/arbouses.png")
	#Global.player_inventory.add_item(inv_item)
	for i in range(Global.player_inventory.items.size()): 
	#for i in range(3):
		draggables[i].visible = true
		objects_slots[i] = i
	close()
	
func _process(_delta):
	if Input.is_action_just_pressed("inventory") and !Global.isPaused:
		if is_open:
			close()
		else:
			if !Global.is_craft_ui_open:
				open()
	
	change_current_slot()
	process_drag_drop()

	if Input.is_action_just_pressed("pause"):
		close()

func update_slides():
	#print(slots[0])
	for i in range(min(Global.player_inventory.items.size(),slots.size())):
		slots[i].update_inventory_visual(Global.player_inventory.items[i])

func open():
	update_slides()
	visible = true
	is_open = true
	Global.is_inventory_open = true
	
func close():
	visible = false
	is_open = false
	Global.is_inventory_open = false
	
func change_current_slot():
	if Input.is_action_just_pressed("slot_left"):
		if Global.inv_current_slot == 0:
			Global.inv_current_slot = 2
		else:
			Global.inv_current_slot -= 1
	if Input.is_action_just_pressed("slot_right"):
		if Global.inv_current_slot == 2:
			Global.inv_current_slot = 0
		else:
			Global.inv_current_slot += 1
	
	for i in range(slots.size()):
		var texture_rect = slots[i].get_node("TextureRect")

		if i == Global.inv_current_slot:
			texture_rect.texture = load("res://assets/graphical/ui/active_case.png")
		else:
			texture_rect.texture = load("res://assets/graphical/ui/base_case.png")
			
func process_drag_drop():
	
	if hoverred_object != -1 and Input.is_action_just_pressed("left_click"):
		precedent_place = objects_slots[hoverred_object]
		grabbed_object = hoverred_object
		draggables[grabbed_object].get_node("TextureRect").texture = Global.player_inventory.items[grabbed_object].texture
		remove_grabbed(grabbed_object)
	
	if grabbed_object != -1:
		
		if Input.is_action_pressed("left_click"):
			draggables[grabbed_object].global_position = get_global_mouse_position()
		
		elif can_place(): #objet relâché
			draggables[grabbed_object].global_position = droppables[objects_slots[grabbed_object]].global_position
			if objects_slots[grabbed_object] == precedent_place:
				add_grabbed(grabbed_object)
		
		else:
			add_grabbed(grabbed_object)
			draggables[grabbed_object].global_position = droppables[precedent_place].global_position
			objects_slots[grabbed_object] = precedent_place
	
	if Input.is_action_just_released("left_click"):
		draggables[grabbed_object].get_node("TextureRect").texture = null
		if objects_slots[grabbed_object] == 3:
			Global.player_inventory.items[grabbed_object].quantity += 1
			Global.player_inventory.remove_item(Global.player_inventory.items[grabbed_object])
			refresh()
		grabbed_object = -1
		
		
func can_place() -> bool :
	
	if grabbed_object == -1:
		return false
		
	var count := 0
	var comp := objects_slots[grabbed_object]
	if objects_slots[grabbed_object] != 3 and objects_slots[grabbed_object] > Global.player_inventory.items.size()-1:
		return false
		
	for i in range(objects_slots.size()):
		
		if objects_slots[i] == comp:
			count += 1
		if count > 1:
			return false
			
	return true
	
func refresh():
	grabbed_object = -1
	hoverred_object = -1
	precedent_place = -1 
	objects_slots = [-1, -1, -1]
	
	for drag in draggables:
		drag.hide()
	
	for i in range(inventory.items.size()): 
	#for i in range(3):
		draggables[i].global_position = droppables[i].global_position
		draggables[i].visible = true
		objects_slots[i] = i
	
func add_grabbed(g : int):
	Global.player_inventory.items[grabbed_object].quantity += 1
	slots[g].get_node("item_display").show()
	slots[g].get_node("item_quantity").text = str(Global.player_inventory.items[g].quantity)

func remove_grabbed(g : int):
	Global.player_inventory.items[g].quantity -= 1
	if Global.player_inventory.items[g].quantity <= 0:
		slots[g].get_node("item_display").hide()
		slots[g].get_node("item_quantity").hide()
	slots[g].get_node("item_quantity").text = str(Global.player_inventory.items[g].quantity)

func _on_inventory_ui_slot_mouse_entered() -> void:
	Global.inv_current_slot = 0

func _on_inventory_ui_slot_2_mouse_entered() -> void:
	Global.inv_current_slot = 1

func _on_inventory_ui_slot_3_mouse_entered() -> void:
	Global.inv_current_slot = 2


func _on_area_2d_mouse_entered() -> void:
	print("ALLO")
	hoverred_object = 0

func _on_area_2d_mouse_entered2() -> void:
	hoverred_object = 1

func _on_area_2d_mouse_entered3() -> void:
	hoverred_object = 2

func _on_area_2d_mouse_exited() -> void:
	hoverred_object = -1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if grabbed_object != -1:
		for drop in range(droppables.size()):
			if body == droppables[drop]:
				objects_slots[grabbed_object] = drop


func _on_visibility_changed() -> void:
	if visible:
		refresh()
