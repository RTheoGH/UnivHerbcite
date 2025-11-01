extends Interactable

func _ready() -> void:
	if $"../Control/Button":
		$"../Control/Button".button_up.connect(close_ui)
	if $"../Control".has_signal("ui_opened"):
		$"../Control".ui_opened.connect(narrate_recipe_zone_1)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("inventory"):
		$"../Control".hide()
		Global.is_interactable_ui_open = false


func on_interaction():
	$"../Control".show()
	Global.is_interactable_ui_open = true

func _on_area_exited(area: Area3D) -> void:
	if is_instance_of(area.get_parent(), RayCast3D):
		close_ui()

func close_ui():
	$"../Control".hide()
	Global.is_interactable_ui_open = false

func narrate_recipe_zone_1():
	await get_tree().create_timer(1.0).timeout
	Global.narrate("La recette", "J'ai découvert une recette étrange. À quoi pourrait-elle servir ?")
