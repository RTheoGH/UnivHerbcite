extends Node

var isPaused: bool
var is_inventory_open: bool
var cam_speed = 0.3
var music_volume = 100
var ui_volume = 100

var minimap_activated: bool = false
var carre_minimap: bool = false

var herbier : Array = []

@onready var player_inventory : Inventory = preload("res://inventory/player_inventory.tres")

func _ready() -> void:
	isPaused = false


func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause")):
		isPaused = !isPaused

	if(Input.is_action_just_pressed("fullscreen")):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
