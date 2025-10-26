extends Node

var effects := {
	InventoryItem.InventoryItemEffect.SPEED: {
		"stats": [
			{"target": "player", "property": "SPEED", "boost": 10.0, "default": 5.0},
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

func _apply_effect(player, effect_type):
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
	
func _on_effect_timeout(player, effect_type):
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
	
	active_timers[effect_type].queue_free()
	active_timers.erase(effect_type)
