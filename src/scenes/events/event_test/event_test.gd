extends Node3D

@export var speed = 5.0

@onready var random_bullshit: AnimationPlayer = $AnimalMesh/RandomBullshit
#@onready var path : Path3D = $EventPath_Yessir
#@onready var path_to_follow : PathFollow3D = $EventPath_Yessir/PathFollow3D

var run_away = false
var run_direction = Vector3(0,0,0)

var run_time_remaining := 0.0
@export var run_duration := 3.0

func _ready() -> void:
	var anim = random_bullshit.get_animation("test_anim")
	anim.loop_mode = (Animation.LOOP_LINEAR)

func event_triggered(pos: Vector3) -> void:
	
	random_bullshit.play("test_anim")
	print("Body pos : " + str(pos))
	run_direction = (-position.direction_to(pos)).normalized()
	run_away = true
	run_time_remaining = run_duration

func _process(delta: float) -> void:
	if run_away:
		#if path : 
			#print("Path : " , path)
		pass
	else:
		run_away = false
		queue_free()
