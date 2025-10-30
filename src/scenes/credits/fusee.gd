extends RigidBody3D

func _ready() -> void:
	linear_velocity = Vector3(0, randf() * 10 + 20,0)
	position = Vector3(randf() * 5, 0, randf() * 5)

func _process(_delta: float) -> void:
	if linear_velocity.length() < 1:
		var effect_scene = load("res://src/scenes/credits/artifice.tscn")
		var effect = effect_scene.instantiate()
		effect.position = position
		get_parent().add_child(effect)
		queue_free()
