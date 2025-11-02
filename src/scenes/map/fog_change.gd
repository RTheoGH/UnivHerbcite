extends Area3D

const time := 1.0
@onready var fog_tween: Tween = get_parent().fog_tween
var timer: SceneTreeTimer

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"player"):
		timer = get_tree().create_timer(3.0)
		get_parent().just_entered_toxic_fog = true
		timer.timeout.connect(
			func () :
				if get_parent().just_entered_toxic_fog:
					body.is_in_toxic_fog = true
		)
		print("fog deepens")
		fog_tween = get_tree().create_tween()
		fog_tween.set_parallel()
		fog_tween.tween_property(
			$"../WorldEnvironment".environment,
			"fog_sky_affect",
			0.8,
			time
		)
		
		fog_tween.tween_property(
			$"../WorldEnvironment".environment,
			"fog_density",
			0.1,
			time
		)
		
		fog_tween.tween_property(
			$"../WorldEnvironment".environment,
			"fog_light_color",
			Color(0.339, 0.462, 0.191, 1.0),
			time
		)
