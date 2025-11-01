extends Control

var livre_recupere: bool = false

func _ready() -> void:
	$Book.hide()
	$Options.hide()

func _process(_delta: float) -> void:
	if !Global.isPaused:
		$Options.hide()
	
	if !livre_recupere:
		if Global.book_not_collected:
			$progress.visible = false
			$TextureRect.visible = false
		else:
			$progress.visible = true
			$TextureRect.visible = true
			Global.narrate("Le livre","J'ai ramassé un livre étrange avec des inscriptions de plantes. Certaines parties ont été éffacés")
			livre_recupere = true

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
