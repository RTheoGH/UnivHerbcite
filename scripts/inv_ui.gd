extends Control


@onready var slots : Array = $PanelContainer/MarginContainer/HBoxContainer.get_children()

var is_open = false
var current_slot = 0

func _ready():
	close()
	
func _process(delta):
	if Input.is_action_just_pressed("inventory") and !Global.isPaused:
		print("hello")
		if is_open:
			close()
		else:
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
		if current_slot == 0:
			current_slot = 2
		else:
			current_slot -= 1
	if Input.is_action_just_pressed("slot_right"):
		if current_slot == 2:
			current_slot = 0
		else:
			current_slot += 1
	
	for i in range(slots.size()):
		var texture_rect = slots[i].get_node("TextureRect")

		if i == current_slot:
			texture_rect.texture = load("res://ressources/ui/active_case.png")
		else:
			texture_rect.texture = load("res://ressources/ui/base_case.png")

func _on_inventory_ui_slot_mouse_entered() -> void:
	current_slot = 0

func _on_inventory_ui_slot_2_mouse_entered() -> void:
	current_slot = 1

func _on_inventory_ui_slot_3_mouse_entered() -> void:
	current_slot = 2
