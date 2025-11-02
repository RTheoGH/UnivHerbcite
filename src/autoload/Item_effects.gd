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
	},
	InventoryItem.InventoryItemEffect.JUMP_POTION: {
		"stats": [
			{"target": "player", "property": "JUMP_VELOCITY", "boost": 10.0, "default": 4.5}
		],
		"duration": 30.0
	},
	InventoryItem.InventoryItemEffect.SPEED_POTION: {
		"stats": [
			{"target": "player", "property": "SPEED", "boost": 20.0, "default": 7.5},
			{"target": "camera", "property": "fov", "boost": 100.0, "default": 75.0, "transition": 0.2}
		],
		"duration": 30.0
	},
	InventoryItem.InventoryItemEffect.NAUSEA: {
		"stats": [
			{"target": "overlay"}
		],
		"duration": 10.0
	},
	InventoryItem.InventoryItemEffect.HEALED: {
		"stats": [
			{"target": "player"}
		],
		"duration": 1000000000000.0
	},
	InventoryItem.InventoryItemEffect.POISON_IMMUNE: {
		"stats": [
			{"target": "player"}
		],
		"duration": 10000000000.0
	},
}

var active_timers := {} # pour savoir si effet en cours : active_timers.keys.has(effet_actuel)
var player: Node = null

func _apply_effect(p, effect_type):
	if player == null:
		player = p
	if not effects.has(effect_type):
		return
	
	var effect = effects[effect_type]
	
	for stat in effect["stats"]:
		if stat["target"] == "overlay":
			Overlay.start_nausea()
			continue
		
		var target
		if stat["target"] == "player":
			target = player
		else:
			target = player.get_node("Camera3D")
		
		if "property" in stat:
			if "transition" in stat:
				var tween = get_tree().create_tween()
				tween.tween_property(target, stat["property"], stat["boost"], stat["transition"])
			else:
				target.set(stat["property"], stat["boost"])
			print("Boost " + stat["property"] + " appliqué")

	if active_timers.has(effect_type):
		if active_timers[effect_type] != null:
			active_timers[effect_type].stop()
	else:
		if effect_type == InventoryItem.InventoryItemEffect.HEALED or effect_type == InventoryItem.InventoryItemEffect.POISON_IMMUNE:
			active_timers[effect_type] = null
		else:
			var t := Timer.new()
			t.wait_time = effect["duration"]
			t.one_shot = true
			add_child(t)
			t.connect("timeout", Callable(self, "_on_effect_timeout").bind(player, effect_type))
			active_timers[effect_type] = t
	
	if active_timers[effect_type] != null:
		active_timers[effect_type].start()
	
func _on_effect_timeout(p, effect_type):
	if player == null:
		player = p
	if not effects.has(effect_type):
		return
	
	var effect = effects[effect_type]
	
	for stat in effect["stats"]:
		if stat["target"] == "overlay":
			Overlay.stop_nausea()
			continue
		
		var target
		if stat["target"] == "player":
			target = player
		else:
			target = player.get_node("Camera3D")
		
		if "property" in stat:
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
	elif effect_type == InventoryItem.InventoryItemEffect.NAUSEA:
		player.get_node("Effects/Nausea_icon").hide()
		player.get_node("Effects/Nausea").hide()
	
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
		
		var time_left := 0.0
		if active_timers[effect_type] != null:
			var timer: Timer = active_timers[effect_type]
			time_left = round(timer.time_left)
		
		if effect_type == InventoryItem.InventoryItemEffect.SPEED or effect_type == InventoryItem.InventoryItemEffect.SPEED_POTION:
			var icon: TextureRect = player.get_node("Effects/Speed_icon")
			var label: RichTextLabel = player.get_node("Effects/Speed")
			icon.show()
			label.text = str(int(time_left)) + "s"
			label.show()
		elif effect_type == InventoryItem.InventoryItemEffect.JUMP or effect_type == InventoryItem.InventoryItemEffect.JUMP_POTION:
			var icon: TextureRect = player.get_node("Effects/Jump_icon")
			var label: RichTextLabel = player.get_node("Effects/Jump")
			icon.show()
			label.text = str(int(time_left)) + "s"
			label.show()
		elif effect_type == InventoryItem.InventoryItemEffect.NAUSEA:
			var icon: TextureRect = player.get_node("Effects/Nausea_icon")
			var label: RichTextLabel = player.get_node("Effects/Nausea")
			icon.show()
			label.text = str(int(time_left)) + "s"
			label.show()
		elif effect_type == InventoryItem.InventoryItemEffect.HEALED:
			var icon: TextureRect = player.get_node("Effects/Healed_icon")
			icon.show()
		elif effect_type == InventoryItem.InventoryItemEffect.POISON_IMMUNE:
			var icon: TextureRect = player.get_node("Effects/Poison_icon")
			icon.show()

func is_effect_active(effect: InventoryItem.InventoryItemEffect) -> bool:
	return active_timers.keys().has(effect)
