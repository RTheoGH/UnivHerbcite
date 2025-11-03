extends StaticBody3D

@export var distance_haute_threshold: float = 120.0
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


func _on_fog_change_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
