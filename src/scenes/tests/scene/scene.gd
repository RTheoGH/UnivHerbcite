extends Node3D

var mxw : Tween

var music_bus := AudioServer.get_bus_index("Music")
var low_pass

@export_range(0.0,20000.0,10.0) var hz: float = 700.0 

var was_paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.text_alert = $Perso/TextAlert
	Global.setup_text_alerts()
	
	low_pass = AudioServer.get_bus_effect(music_bus, 0)
	$Map.visible = Global.minimap_activated
	$Pause.visible = false
	$Musique.play()
	
	print(Global.inv_current_slot)
	
	$Perso.reset_objectives()
	$Perso.update_objectives_text()
	
	#maxwell()
	#$maxwell/song.play()
	
	#$Stegosaurus/AnimationPlayer.play("Armature|Stegosaurus_Attack")
	Global.is_craft_ui_open = false

func apply_pause_audio(paused: bool) -> void:
	var tween = create_tween()
	if paused:
		tween.tween_property(low_pass, "cutoff_hz", hz, 0.5)
	else:
		tween.tween_property(low_pass, "cutoff_hz", 20000.0, 0.5)

func _process(_delta: float) -> void:
	if Global.isPaused != was_paused:
		apply_pause_audio(Global.isPaused)
		was_paused = Global.isPaused
	
	if Global.isPaused:
		$Pause.visible = true
		$Map.visible = false
		#AudioServer.set_bus_mute(music_bus,true)
	else:
		$Pause.visible = false
		$Map.visible = Global.minimap_activated
		#AudioServer.set_bus_mute(music_bus,false)
	#if Global.is_craft_ui_open:
		#$CraftUI.visible = true
	#else:
		#$CraftUI.visible = false
	
	if Input.is_action_just_pressed("ouvrir_livre") \
	and !Global.is_inventory_open \
	and !Global.is_craft_ui_open \
	and !Global.is_chest_open:
		if !Global.isPaused:
			$Pause.visible = true
			$Pause.get_node("Book").visible = true
			$Pause.get_node("Book").show_book()
		else:
			$Pause.visible = false
			$Pause.get_node("Book").visible = false
			$Pause.get_node("Book").show_book()
		Global.isPaused = !Global.isPaused

func maxwell():
	if mxw:
		mxw.kill()
	
	mxw = create_tween()
	mxw.set_loops()
	mxw.tween_property($maxwell, "rotation_degrees:z", -30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", -30, 0.2)
