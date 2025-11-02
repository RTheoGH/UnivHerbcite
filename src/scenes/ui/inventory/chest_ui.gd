extends Control

signal chest_closed(chest_inv : Inventory)

var is_open = false
var chest_inventory : Inventory
@onready var chest_ui_inv := get_tree().get_nodes_in_group("chest_inventory")
@onready var ui_inventory := get_tree().get_nodes_in_group("player_inventory")
var hoverred_slot : int = -1

var discovered_olives: bool = false

func _ready() -> void:
	chest_inventory = Inventory.new()
	chest_inventory.invSize = 10
	chest_inventory.stackSize = 16
	refresh()

func _process(_delta: float) -> void:
	#discover_olives()
	
	if Input.is_action_just_pressed("inventory") or Input.is_action_just_pressed("pause"):
		chest_closed.emit(chest_inventory)
		Global.is_chest_open = false
		hide()

	if hoverred_slot != -1:
		if Input.is_action_just_pressed("left_click"):
			if hoverred_slot < 10 and hoverred_slot < chest_inventory.items.size():
				var possible := Global.player_inventory.add_item_copy(chest_inventory.items[hoverred_slot], false)
				if possible:
					chest_inventory.remove_item(chest_inventory.items[hoverred_slot])
			elif hoverred_slot >= 10 and hoverred_slot-10 < Global.player_inventory.items.size():
				var possible := chest_inventory.add_item_copy(Global.player_inventory.items[hoverred_slot-10], true)
				if possible:
					Global.player_inventory.remove_item(Global.player_inventory.items[hoverred_slot-10])
				
			refresh()

		if Input.is_action_just_pressed("right_click"):
			if hoverred_slot < 10 and hoverred_slot < chest_inventory.items.size():
				var possible := true
				while possible and chest_inventory.items[hoverred_slot].quantity > 0:
					possible = Global.player_inventory.add_item_copy(chest_inventory.items[hoverred_slot], false)
					if possible:
						if chest_inventory.items[hoverred_slot].quantity == 1:
							possible = false
						chest_inventory.remove_item(chest_inventory.items[hoverred_slot])
			elif hoverred_slot >= 10 and hoverred_slot-10 < Global.player_inventory.items.size():
				var possible := true
				while possible and Global.player_inventory.items[hoverred_slot-10].quantity > 0:
					possible = chest_inventory.add_item_copy(Global.player_inventory.items[hoverred_slot-10], true)
					if possible:
						if Global.player_inventory.items[hoverred_slot-10].quantity == 1:
							possible = false
						Global.player_inventory.remove_item(Global.player_inventory.items[hoverred_slot-10])
			
			refresh()


func refresh():
	print(Global.player_inventory.items.size())
	for i in range(ui_inventory.size()):
		#ui_inventory[i].get_node()
		if i < Global.player_inventory.items.size():
			ui_inventory[i].update_inventory_visual(Global.player_inventory.items[i])
		else:
			ui_inventory[i].get_node("item_display").texture = null
			ui_inventory[i].get_node("item_quantity").text = ""
	
	for c in range(chest_ui_inv.size()):
		if c < chest_inventory.items.size():
			chest_ui_inv[c].update_inventory_visual(chest_inventory.items[c])
		else:
			chest_ui_inv[c].get_node("item_display").texture = null
			chest_ui_inv[c].get_node("item_quantity").text = ""

func _on_interactable_chest_opened(inv: Inventory) -> void:
	show()
	is_open = true
	chest_inventory = inv
	Global.is_chest_open = true
	refresh()

func _on_area_exited(area: Area3D) -> void:
	if is_instance_of(area.get_parent(), RayCast3D):
		chest_closed.emit(chest_inventory)
		hide()
		is_open = false
		Global.is_chest_open = false


func _on_inventory_ui_slot_mouse_entered(index : int) -> void:
	hoverred_slot = index


func _on_inventory_ui_slot_mouse_exited() -> void:
	hoverred_slot = -1

############################

func discover_olives():
	if !discovered_olives:
		for item in chest_inventory.items:
			if item.type == InventoryItem.InventoryItemType.OLIVES:
				print("discovered olives")
				load(Global.all_ingredient_items[item.type]).revele = true
				discovered_olives = true
