extends StaticBody3D

@export var distance_haute_threshold: float = 80.0
var distance_basse_threshold: float # hysteresis

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distance_basse_threshold = distance_haute_threshold - 5.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var active_cam = get_viewport().get_camera_3d()
	if Global.lod_distance:
		if $"Sprite3D" and active_cam:
			if (active_cam.global_position - global_position).length_squared() < distance_basse_threshold**2:
				$TreeBas.show()
				$TreeHaut.show()
				$"Sprite3D".hide()
			elif (active_cam.global_position - global_position).length_squared() > distance_haute_threshold**2:
				$TreeBas.hide()
				$TreeHaut.hide()
				$"Sprite3D".show()
	else:
		$TreeBas.show()
		$TreeHaut.show()
		$"Sprite3D".hide()
		#else:
			#var taux_alpha =  (distance_haute_threshold - (active_cam.global_position - global_position).length()) / distance_basse_threshold
			#
			#if distance_haute_threshold < 100.0:
				#print(taux_alpha)
				#print($TreeBas.material_override.get_shader_parameter("opacity"))
			#$TreeBas.material_override.set_shader_parameter("opacity", taux_alpha)
			##$TreeHaut.multimesh.mesh.material.set_shader_parameter("albedo:a", 1.0-taux_alpha)
			#$"Sprite3D".modulate.a = 1.0-taux_alpha


func _on_fog_change_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
