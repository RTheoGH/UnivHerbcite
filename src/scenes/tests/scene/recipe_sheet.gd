extends Interactable


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$"../Control".hide()
		Global.is_interactable_ui_open = false


func on_interaction():
	$"../Control".show()
	Global.is_interactable_ui_open = true



func _on_area_exited(area: Area3D) -> void:
	if is_instance_of(area.get_parent(), RayCast3D):
		$"../Control".hide()
		Global.is_interactable_ui_open = false
