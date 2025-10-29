extends Node3D

@export var speed = 5.0

@onready var path : Path3D = $Path3D
@onready var path_to_follow : PathFollow3D = $Path3D/PathFollow3D

var run_away = false
var run_direction = Vector3(0,0,0)

var run_time_remaining := 0.0
@export var run_duration := 3.0

func event_triggered(pos: Vector3) -> void:
	
	print("Body pos : " + str(pos))
	run_direction = (-position.direction_to(pos)).normalized()
	run_away = true
	run_time_remaining = run_duration

func _process(delta: float) -> void:
	if run_away:
		if run_time_remaining > 0.0:
			position += run_direction * speed * delta
			run_time_remaining -= delta


		else:
			run_away = false
			queue_free()
