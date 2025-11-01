extends Node3D

@export var speed = 10

@onready var path : Path3D = $Path3D
@onready var path_to_follow : PathFollow3D = $Path3D/PathFollow3D

@onready var anim_player : AnimationPlayer = $Sketchfab_Scene/AnimationPlayer

var run_away = false
var run_direction = Vector3(0,0,0)

signal event_finished

func event_triggered(pos: Vector3) -> void:
	run_away = true

func _process(delta: float) -> void:
	if run_away:
		# TODO Handle no path case
		if path_to_follow.progress_ratio < 0.98 :
			path_to_follow.progress += speed * delta
			position = path_to_follow.position 
			rotation.y = path_to_follow.rotation.y + deg_to_rad(180)
			
			anim_player.play("Scene")
			
		else:
			run_away = false
			queue_free()
			event_finished.emit()
	else : 
		#TODO : Handle idle
		pass
