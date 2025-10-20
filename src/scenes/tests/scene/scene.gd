extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Map.visible = Global.minimap_activated
	$Pause.visible = false
	$Musique.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.isPaused:
		$Pause.visible = true
		$Map.visible = false
		$Musique.stream_paused = true
	else:
		$Pause.visible = false
		$Map.visible = Global.minimap_activated
		$Musique.stream_paused = false
	
	if Input.is_action_just_pressed("ouvrir_livre"):
		if !Global.isPaused:
			$Pause.visible = true
			$Pause.get_node("Book").visible = true
		else:
			$Pause.visible = false
			$Pause.get_node("Book").visible = false
		Global.isPaused = !Global.isPaused
