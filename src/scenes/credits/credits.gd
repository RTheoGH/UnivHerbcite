extends Node3D

var mxw : Tween
var is_activated : bool = false

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("inventory")) and $Control.visible == true:
		$Control.hide()
		Global.is_interactable_ui_open = false

func _on_timer_timeout() -> void:
	if is_activated:
		var rocket_scene = load("res://src/scenes/credits/fusee.tscn")
		var rocket = rocket_scene.instantiate()
		add_child(rocket)

func _on_interactable_on_interaction_signal() -> void:
	if Global.inv_current_slot < Global.player_inventory.items.size() and Global.player_inventory.items[Global.inv_current_slot].type == InventoryItem.InventoryItemType.POTION_BLEUE:
		Global.player_inventory.remove_item(Global.player_inventory.items[Global.inv_current_slot])
		maxwell()
		$song.play()
		is_activated = true
	else:
		$Control.show()
		Global.is_interactable_ui_open = true

func maxwell():
	if mxw:
		mxw.kill()
	
	mxw = create_tween()
	mxw.set_loops()
	mxw.tween_property($maxwell, "rotation_degrees:z", -30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", 30, 0.2)
	mxw.tween_property($maxwell, "rotation_degrees:z", -30, 0.2)


func _on_interactable_area_exited(area: Area3D) -> void:
	if(is_instance_of(area.get_parent(), RayCast3D)):
		$Control.hide()
		Global.is_interactable_ui_open = false
	


func _on_button_button_up() -> void:
	$Control.hide()
	Global.is_interactable_ui_open = false
