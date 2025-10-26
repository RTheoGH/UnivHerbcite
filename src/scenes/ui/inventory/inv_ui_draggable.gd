extends Control
var grabbed_object: int = -1
var hoverred_object: int = -1
var hoverred_slot: Vector2
@onready var inventory_objects := [$Object1, $Object2, $Object3]
var objects_slots : Array[Vector2]
@onready var inventory_slots_positions := [$Place1.global_position, $Place2.global_position, $Place3.global_position]
var precedent_place : Vector2 = Vector2(0, 0)
var crafting_place := [-1, -1, -1]
var result : InventoryItem = null

var craft_ui_textures = {
	"base" : preload("res://assets/graphical/ui/craft.png"),
	"complete" : preload("res://assets/graphical/ui/craft_complete.png")
}

func _ready() -> void:
	
	objects_slots.resize(3)
	
	for i in range(Global.player_inventory.items.size()):
		inventory_objects[i].get_node("TextureRect").texture = Global.player_inventory.items[i].texture
		inventory_objects[i].visible = true
		objects_slots[i] = inventory_slots_positions[i]

func _process(_delta: float) -> void:
	if hoverred_object != -1 and Input.is_action_just_pressed("left_click"):
		precedent_place = objects_slots[hoverred_object]
		grabbed_object = hoverred_object

	if grabbed_object != -1:
		
		if Input.is_action_pressed("left_click"):
			inventory_objects[grabbed_object].global_position = get_global_mouse_position()
		
		# Objet relâché
		elif can_place():
			inventory_objects[grabbed_object].global_position = objects_slots[grabbed_object]
			grabbed_object = -1
			
			var ings := get_current_ingredients()
			for r in Global.recipes:
				if r.can_craft(ings):
					result = r.result
					$TextureRect2.texture = result.texture
					$RichTextLabel.text = str(InventoryItem.InventoryItemType.find_key(result.type))
					$TextureRect.texture = craft_ui_textures["complete"]
				else:
					$TextureRect2.texture = null
					$RichTextLabel.text = ""
					$TextureRect.texture = craft_ui_textures["base"]
			
		else:
			print("Pas le droit de placer ici !")
			inventory_objects[grabbed_object].global_position = precedent_place
			objects_slots[grabbed_object] = precedent_place
			
	if Input.is_action_just_released("left_click"):
		grabbed_object = -1

func can_place() -> bool :
	
	if grabbed_object == -1:
		return false
		
	var count := 0
	var comp := objects_slots[grabbed_object]
	for i in range(objects_slots.size()):
		
		if objects_slots[i] == comp:
			count += 1
		if count > 1:
			return false
	
	return true

func refresh() -> void:
	
	grabbed_object = -1
	hoverred_object= -1
	inventory_objects = [$Object1, $Object2, $Object3]
	precedent_place = Vector2.ZERO
	crafting_place = [-1, -1, -1]
	result = null
	objects_slots.clear()
	objects_slots.resize(3)
	
	for i in range(inventory_objects.size()):
		inventory_objects[i].global_position = inventory_slots_positions[i]
		inventory_objects[i].visible = false
	
	for i in range(Global.player_inventory.items.size()):
		inventory_objects[i].get_node("TextureRect").texture = Global.player_inventory.items[i].texture
		inventory_objects[i].visible = true
		objects_slots[i] = inventory_slots_positions[i]

	$TextureRect2.texture = null
	$RichTextLabel.text = ""

func get_current_ingredients() -> Array[InventoryItem]:
	var places := [$Place4, $Place5, $Place6]
	var res : Array[InventoryItem] = [null, null, null]
	for o in range(len(inventory_objects)):
		for p in range(len(places)):
			if inventory_objects[o].get_node("Area2D").get_overlapping_bodies().has(places[p]):
				res[p] = Global.player_inventory.items[o]
	return res

func _on_area_2d_mouse_entered(obj : int) -> void:
	if grabbed_object == -1:
		hoverred_object = obj

func _on_area_2d_mouse_exited() -> void:
	hoverred_object = -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if grabbed_object != -1 and body not in $"InvUi".get_children():
		objects_slots[grabbed_object] = body.global_position

func _on_confirm_button_up() -> void:
	var current_ings := get_current_ingredients()
	if result != null && Global.player_inventory.can_add_craft(current_ings):
		Global.player_inventory.consume_items(current_ings)
		Global.player_inventory.add_item(result)
		$Complete.play()
		if $TextureRect.texture == craft_ui_textures["complete"]:
			$TextureRect.texture = craft_ui_textures["base"]
		refresh()

func _on_confirm_2_button_up() -> void:
	Global.is_craft_ui_open = false
	result = null

func _on_visibility_changed() -> void:
	if visible:
		refresh()


func _on_interactable_crafting_opened() -> void:
	show()
	Global.is_craft_ui_open = true


func _on_interactable_area_exited(area: Area3D) -> void:
	if is_instance_of(area.get_parent(), RayCast3D):
		hide()
		Global.is_craft_ui_open = false
