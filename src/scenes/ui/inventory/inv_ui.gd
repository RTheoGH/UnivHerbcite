extends Control


@onready var slots : Array = $PanelContainer/MarginContainer/HBoxContainer.get_children()

var is_open = false

func _ready():
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("inventory") and !Global.isPaused:
		print("hello")
		if is_open:
			close()
		else:
			if !Global.is_craft_ui_open:
				open()
	
	change_current_slot()

	if Input.is_action_just_pressed("pause"):
		close()

func update_slides():
	print(slots[0])
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

func _on_inventory_ui_slot_mouse_entered() -> void:
	Global.inv_current_slot = 0

func _on_inventory_ui_slot_2_mouse_entered() -> void:
	Global.inv_current_slot = 1

func _on_inventory_ui_slot_3_mouse_entered() -> void:
	Global.inv_current_slot = 2
