extends Node3D

@onready var particles = $CPUParticles3D

func _ready() -> void:
	$CPUParticles3D.one_shot = true
	var test = (randi() % 5)
	$CPUParticles3D.color_ramp = load("res://assets/game_resources/credits/fusee_grad_%d.tres" % test)
	
	
func _process(_delta: float) -> void:
	if !particles.emitting:
		queue_free()
