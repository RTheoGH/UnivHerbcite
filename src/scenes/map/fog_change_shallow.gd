extends Area3D

const time := 1.0
@onready var fog_tween: Tween = get_parent().fog_tween
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"player"):
		print("fog shallowens")
		
		fog_tween = get_tree().create_tween()
		fog_tween.set_parallel()
		fog_tween.tween_property(
			$"../WorldEnvironment".environment,
			"fog_sky_affect",
			0.174,
			time
		)
		
		fog_tween.tween_property(
			$"../WorldEnvironment".environment,
			"fog_density",
			0.02,
			time
		)
		
		fog_tween.tween_property(
			$"../WorldEnvironment".environment,
			"fog_light_color",
			Color(0.365, 0.286, 0.149),
			time
		)
		
