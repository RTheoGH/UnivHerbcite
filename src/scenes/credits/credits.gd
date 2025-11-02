extends Node3D

var mxw : Tween
var is_activated : bool = false

var first_dialog = true
var quest_started: bool = false

func _ready() -> void:
	#Global.player_inventory.add_item(load("res://assets/game_resources/items/potions/potion_bleue.tres"))
	pass

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
	if !is_activated:
		if !Global.blue_potion_used:
			if Global.inv_current_slot < Global.player_inventory.items.size() \
			and Global.player_inventory.items[Global.inv_current_slot].type == InventoryItem.InventoryItemType.POTION_BLEUE:
				if quest_started:
					$Control2.show()
					Global.is_interactable_ui_open = true
				else:
					$Control5.show()
					Global.is_interactable_ui_open = true
				#Global.player_inventory.remove_item(Global.player_inventory.items[Global.inv_current_slot])
				while Global.is_interactable_ui_open:
					await get_tree().process_frame
				maxwell()
				$song.play()
				is_activated = true
				Global.maxwell_quest_completed = true
			else:
				$Control.show()
				Global.is_interactable_ui_open = true
				quest_started = true
		else:
			if !quest_started:
				$Control3.show()
				Global.is_interactable_ui_open = true
			else:
				$Control4.show()
				Global.is_interactable_ui_open = true
			while Global.is_interactable_ui_open:
				await get_tree().process_frame
			maxwell()
			$song.play()
			is_activated = true
			Global.narrate("Le remède","D'après le chat, l'étrange potion bleue était un remède. Il m'informe que je peux quitter cet endroit sereinement désormais.")
			Global.maxwell_quest_completed = true

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

func _on_button_2_button_up() -> void:
	$Control2.hide()
	Global.is_interactable_ui_open = false

func _on_button_3_button_up() -> void:
	$Control3.hide()
	Global.is_interactable_ui_open = false

func _on_button_4_button_up() -> void:
	$Control4.hide()
	Global.is_interactable_ui_open = false

func _on_button_5_button_up() -> void:
	$Control5.hide()
	Global.is_interactable_ui_open = false
