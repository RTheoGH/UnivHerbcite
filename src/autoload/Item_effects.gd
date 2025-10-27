extends Node

var effects := {
	InventoryItem.InventoryItemEffect.SPEED: {
		"stats": [
			{"target": "player", "property": "SPEED", "boost": 15.0, "default": 7.5},
			{"target": "camera", "property": "fov", "boost": 90.0, "default": 75.0, "transition": 0.2}
		],
		"duration": 10.0
	},
	InventoryItem.InventoryItemEffect.JUMP: {
		"stats": [
			{"target": "player", "property": "JUMP_VELOCITY", "boost": 7.0, "default": 4.5}
		],
		"duration": 10.0
	}
}

var active_timers := {}
var player: Node = null

func _apply_effect(p, effect_type):
	if player == null:
		player = p
	if not effects.has(effect_type):
		return
	
	var effect = effects[effect_type]
	
	for stat in effect["stats"]:
		var target
		if stat["target"] == "player":
			target = player
		else:
			target = player.get_node("Camera3D")
			
		if "transition" in stat:
			var tween = get_tree().create_tween()
			tween.tween_property(target, stat["property"], stat["boost"], stat["transition"])
		else:
			target.set(stat["property"], stat["boost"])
		print("Boost " + stat["property"] + " appliqué")

	if active_timers.has(effect_type):
		active_timers[effect_type].stop()
	else:
		var t := Timer.new()
		t.wait_time = effect["duration"]
		t.one_shot = true
		add_child(t)
		t.connect("timeout", Callable(self, "_on_effect_timeout").bind(player, effect_type))
		active_timers[effect_type] = t
	
	active_timers[effect_type].start()
	
func _on_effect_timeout(p, effect_type):
	if player == null:
		player = p
	if not effects.has(effect_type):
		return
	
	var effect = effects[effect_type]
	
	for stat in effect["stats"]:
		var target
		if stat["target"] == "player":
			target = player
		else:
			target = player.get_node("Camera3D")
		
		if "transition" in stat:
			var tween = get_tree().create_tween()
			tween.tween_property(target, stat["property"], stat["default"], stat["transition"])
		else:
			target.set(stat["property"], stat["default"])
		print("Fin du boost " + stat["property"])
	
	if effect_type == InventoryItem.InventoryItemEffect.SPEED:
		player.get_node("Effects/Speed_icon").hide()
		player.get_node("Effects/Speed").hide()
	elif effect_type == InventoryItem.InventoryItemEffect.JUMP:
		player.get_node("Effects/Jump_icon").hide()
		player.get_node("Effects/Jump").hide()
	
	active_timers[effect_type].queue_free()
	active_timers.erase(effect_type)
	
	if active_timers.size() == 0:
		player.get_node("Effects").hide()

func _process(_delta: float) -> void:
	if player == null or active_timers.size() == 0:
		return
	
	var effects_ui = player.get_node("Effects")
	for child in effects_ui.get_children():
		child.hide()
	
	effects_ui.show()
	for effect_type in active_timers.keys():
		var timer: Timer = active_timers[effect_type]
		var time_left: float = round(timer.time_left)
		
		if effect_type == InventoryItem.InventoryItemEffect.SPEED:
			var icon: TextureRect = player.get_node("Effects/Speed_icon")
			var label: RichTextLabel = player.get_node("Effects/Speed")
			icon.show()
			label.text = str(int(time_left)) + "s"
			label.show()
		elif effect_type == InventoryItem.InventoryItemEffect.JUMP:
			var icon: TextureRect = player.get_node("Effects/Jump_icon")
			var label: RichTextLabel = player.get_node("Effects/Jump")
			icon.show()
			label.text = str(int(time_left)) + "s"
			label.show()
