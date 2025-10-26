extends Node

var isPaused: bool
var is_inventory_open: bool
var is_craft_ui_open: bool
var is_chest_open: bool
var cam_speed = 0.3
var is_dragging = false

var minimap_activated: bool = false
var carre_minimap: bool = false

var herbier : Array = []
var recipes : Array[ItemRecipe] = [
	load("res://src/classes/inventory/recipes/potion_rouge.tres") # Ajouter les autres
]

@onready var player_inventory : Inventory = preload("res://assets/game_resources/player_inventory.tres")
var inv_current_slot: int = 0

var text_alert: TextAlert

func _ready() -> void:
	isPaused = false

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("pause") and !is_craft_ui_open and !is_chest_open):
		isPaused = !isPaused

	if Global.is_craft_ui_open and Input.is_action_just_pressed("pause"):
		is_craft_ui_open = !is_craft_ui_open

	if Global.is_chest_open and Input.is_action_just_pressed("pause"):
		is_chest_open = !is_chest_open

	if(Input.is_action_just_pressed("fullscreen")):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func setup_text_alerts():
	print("Alerts connected")
	if player_inventory and text_alert:
		player_inventory.connect("stack_item", text_alert._on_stack_item)
		player_inventory.connect("inventory_full", text_alert._on_inventory_full)
		
	for wall in get_tree().get_nodes_in_group("walls"):
		if wall.has_signal("wall_item_required"):
			wall.connect("wall_item_required", text_alert._on_wall_item_required)
		wall.connect("wall_removed", text_alert._on_wall_removed)
		
func is_ui_open() -> bool:
	return is_chest_open or is_craft_ui_open or is_inventory_open
