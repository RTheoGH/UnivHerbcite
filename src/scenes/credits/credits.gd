extends Node3D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var rocket_scene = load("res://src/scenes/credits/fusee.tscn")
	var rocket = rocket_scene.instantiate()
	add_child(rocket)
