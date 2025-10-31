extends StaticBody3D

@export var distance_haute_treshold: float = 100.0
var distance_basse_treshold: float # hysteresis

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distance_basse_treshold = distance_haute_treshold - 5.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var active_cam = get_viewport().get_camera_3d()
	if $"MultiSprite3D" and active_cam:
		if (active_cam.global_position - global_position).length_squared() < distance_basse_treshold**2:
			$TreeBas.show()
			$TreeHaut.show()
			$"MultiSprite3D".hide()
		elif (active_cam.global_position - global_position).length_squared() > distance_haute_treshold**2:
			$TreeBas.hide()
			$TreeHaut.hide()
			$"MultiSprite3D".show()
