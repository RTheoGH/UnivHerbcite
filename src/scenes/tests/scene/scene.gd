extends Node3D

var mxw : Tween

var music_bus = AudioServer.get_bus_index("Music")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Map.visible = Global.minimap_activated
	$Pause.visible = false
	$Musique.play()
	
	maxwell()
	$maxwell/song.play()
	
	$Stegosaurus/AnimationPlayer.play("Armature|Stegosaurus_Attack")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.isPaused:
		$Pause.visible = true
		$Map.visible = false
		AudioServer.set_bus_mute(music_bus,true)
	else:
		$Pause.visible = false
		$Map.visible = Global.minimap_activated
		AudioServer.set_bus_mute(music_bus,false)
	
	if Input.is_action_just_pressed("ouvrir_livre") and !Global.is_inventory_open:
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
