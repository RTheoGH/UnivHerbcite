extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Book.hide()
	$Options.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.isPaused:
		$Options.hide()
	pass


func _on_continuer_pressed() -> void:
	$select.play()
	Global.isPaused = false
	

func _on_quitter_pressed() -> void:
	$select.play()
	Global.isPaused = false
	get_tree().change_scene_to_file("res://src/scenes/ui/menu/Menu.tscn")


func _on_progress_pressed() -> void:
	$open.play()
	$Book.show()
	$Book/AnimatedSprite2D.play("default")

func _on_options_pressed() -> void:
	$select.play()
	$Options.show()
