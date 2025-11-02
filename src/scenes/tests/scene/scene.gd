extends Node3D

var music_bus := AudioServer.get_bus_index("Music")
var low_pass

@export_range(0.0,20000.0,10.0) var hz: float = 700.0 

var was_paused := false

var book_bloque: bool = true

func _ready() -> void:
	Global.text_alert = $Perso/TextAlert
	Global.setup_text_alerts()
	
	low_pass = AudioServer.get_bus_effect(music_bus, 0)
	$Map.visible = Global.minimap_activated
	$Pause.visible = false
	$Musique.play()
	
	$Perso.reset_objectives()
	$Perso.update_objectives_text()
	#$Stegosaurus/AnimationPlayer.play("Armature|Stegosaurus_Attack")
	Global.is_craft_ui_open = false
	Global.player_inventory.items.clear()
	
	start_intro_narration(2.5)

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
	
	if Global.isPaused and !Global.is_narration_showing:
		$Pause.visible = true
		$Map.visible = false
	else:
		$Pause.visible = false
		$Map.visible = Global.minimap_activated
	#if Global.is_craft_ui_open:
		#$CraftUI.visible = true
	#else:
		#$CraftUI.visible = false
		
	if book_bloque:
		if !Global.book_not_collected:
			$book_bloque.queue_free()
			book_bloque = false
	
	if Input.is_action_just_pressed("ouvrir_livre") and !Global.is_ui_open() \
	and !Global.book_not_collected:
		if !Global.isPaused:
			$Pause.visible = true
			$Pause.get_node("Book").visible = true
			$Pause.get_node("Book").show_book()
		else:
			$Pause.visible = false
			$Pause.get_node("Book").visible = false
			$Pause.get_node("Book").show_book()
		Global.isPaused = !Global.isPaused

func start_intro_narration(delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	Global.narrate("Le réveil", "Je me suis reveillé à l'université. J'ai l'impression d'être au S-pace mais quelque chose est étrange...")
