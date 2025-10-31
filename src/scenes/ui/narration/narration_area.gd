extends Area3D

@onready var player = preload("res://src/scenes/personnage/personnage.tscn")
@export var title: String
@export var message: String

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Perso":
		await get_tree().create_timer(3).timeout
		Global.narrate(title,message)
		queue_free()
