extends Node

var isPaused: bool
var is_inventory_open: bool
var is_craft_ui_open: bool
var is_chest_open: bool

var is_interactable_ui_open: bool
var is_narration_showing: bool
var cam_speed = 0.3
var is_dragging = false

var minimap_activated: bool = false
var carre_minimap: bool = false

var paused_timers: bool = false
var fps: bool = false
var guidage: bool = true

var book_not_collected: bool = true

var maxwell_quest_completed : bool = false
var blue_potion_used : bool = false

var lod_distance: bool = true

var herbier : Array = []
var discoveries : Array = []
var recipes : Array[ItemRecipe] = [
	load("res://src/classes/inventory/recipes/potion_verte.tres"),
	load("res://src/classes/inventory/recipes/potion_violette.tres"),
	load("res://src/classes/inventory/recipes/potion_rouge.tres"),
	load("res://src/classes/inventory/recipes/potion_jaune.tres"),
	load("res://src/classes/inventory/recipes/potion_bleue.tres")
]
var all_ingredient_items : Array[String] = [
	"res://assets/game_resources/items/ingredients/Jujubes.tres",
	"res://assets/game_resources/items/ingredients/Arbouses.tres",
	"res://assets/game_resources/items/ingredients/Asperges.tres",
	"res://assets/game_resources/items/ingredients/Myrobolans.tres",
	"res://assets/game_resources/items/ingredients/Olives.tres",
	"res://assets/game_resources/items/ingredients/Figues.tres",
	"res://assets/game_resources/items/ingredients/lavandes.tres",
	"res://assets/game_resources/items/ingredients/Lierre_item.tres",
	"res://assets/game_resources/items/ingredients/Romarin_item.tres"
]

var all_plantes : Array[String] = [
	"res://assets/game_resources/plantes/Jujubier.tres",
	"res://assets/game_resources/plantes/Arbousier.tres",
	"res://assets/game_resources/plantes/Asperge.tres",
	"res://assets/game_resources/plantes/Myrobolan.tres",
	"res://assets/game_resources/plantes/Olivier.tres",
	"res://assets/game_resources/plantes/Figuier.tres",
	"res://assets/game_resources/plantes/Lavande.tres",
	"res://assets/game_resources/plantes/Lierre.tres",
	"res://assets/game_resources/plantes/Romarin.tres"
]

@onready var player_inventory : Inventory = preload("res://assets/game_resources/player_inventory.tres")
var inv_current_slot: int = 0

var text_alert: TextAlert

var objectives = {
	"space_1": "Explorer et trouver un moyen de sortir du Space.",
	"space_2": "Créer une potion rouge afin d'ouvrir le passage.",
	"space_3": "Explorer les alentours du Space.",
	"fac_1": "Debug pour le moment"
}

var objectives_order = {
	"space_1": 0,
	"space_2": 1,
	"space_3": 2,
	"fac_1": 3
}

var narration_ui

func narrate(title: String, message:String):
	while Global.isPaused:
		await get_tree().process_frame
	narration_ui.set_narration(title,message)
	narration_ui.fade_in()
	
#func set_narration_font_size(size: int):
	#narration_ui.theme_override_font_sizes
	

func _ready() -> void:
	isPaused = false
	

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("pause") and !is_craft_ui_open and !is_chest_open and !is_narration_showing):
		isPaused = !isPaused

	if Global.is_craft_ui_open and Input.is_action_just_pressed("pause"):
		is_craft_ui_open = !is_craft_ui_open

	if Global.is_chest_open and Input.is_action_just_pressed("pause"):
		is_chest_open = !is_chest_open

	if Global.isPaused:
		if !paused_timers:
			for timer in ItemEffects.active_timers:
				var t = ItemEffects.active_timers[timer]
				if t != null:
					t.paused = true
			paused_timers = true

	if !Global.isPaused and paused_timers:
		for timer in ItemEffects.active_timers:
			var t = ItemEffects.active_timers[timer]
			if t != null:
				t.paused = false
		paused_timers = false

	

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
	return is_chest_open or is_craft_ui_open or is_inventory_open or is_interactable_ui_open
