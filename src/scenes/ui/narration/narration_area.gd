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
		if title == "La fin":
			while Global.isPaused:
				await get_tree().process_frame
			Global.fin = true
			await Overlay.fade_to_black(3.0)
			Overlay.fade_from_black(3.0)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_packed(preload("res://src/scenes/ui/menu/Menu.tscn"))
		queue_free()
		
