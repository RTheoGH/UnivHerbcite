extends Node

@onready var material: ShaderMaterial = load("res://assets/shaders/feuilles.tres")
var wind_time = 0.0

func _process(delta):
	wind_time += delta
	material.set_shader_parameter("global_wind_time", wind_time)
