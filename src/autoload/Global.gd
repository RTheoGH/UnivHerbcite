extends Node

var isPaused: bool
var is_inventory_open: bool
var is_craft_ui_open: bool
var cam_speed = 0.3
#var music_volume = 100
#var ui_volume = 100
var is_dragging = false

var minimap_activated: bool = false
var carre_minimap: bool = false

var herbier : Array = []
var recipes : Array[ItemRecipe] = [
	load("res://src/classes/inventory/recipes/potion_rouge.tres") # Ajouter les autres
]

@onready var player_inventory : Inventory = preload("res://assets/game_resources/player_inventory.tres")

func _ready() -> void:
	isPaused = false


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause") and !is_craft_ui_open):
		isPaused = !isPaused

	if Global.is_craft_ui_open and Input.is_action_just_pressed("pause"):
		is_craft_ui_open = !is_craft_ui_open

	if(Input.is_action_just_pressed("fullscreen")):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
