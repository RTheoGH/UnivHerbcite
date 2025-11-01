extends MeshInstance3D

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass
	

func _on_interactable_on_interaction_signal(area: Area3D) -> void:
	Global.get_book = true
	queue_free()
