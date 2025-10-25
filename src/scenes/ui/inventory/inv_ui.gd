extends Control


@onready var slots : Array = $PanelContainer/MarginContainer/HBoxContainer.get_children()
@onready var info_panels = [$Infos/P1, $Infos/P2, $Infos/P3]

var is_open = false

var slot_textures = {
	"base": preload("res://assets/graphical/ui/base_case.png"),
	"active": preload("res://assets/graphical/ui/active_case.png")
}

func _ready():
	close()
	$Infos.hide()
	
func _process(_delta):
	if Input.is_action_just_pressed("inventory") and !Global.isPaused:
		if is_open:
			close()
		else:
			if !Global.is_craft_ui_open:
				open()
	
	if Input.is_action_just_pressed("pause"):
		close()
	
	change_current_slot()

func update_slides():
	#print(slots[0])
	for i in range(min(Global.player_inventory.items.size(),slots.size())):
		slots[i].update_inventory_visual(Global.player_inventory.items[i])


func open():
	update_slides()
	visible = true
	is_open = true
	Global.is_inventory_open = true
	
func close():
	visible = false
	is_open = false
	Global.is_inventory_open = false
	
func change_current_slot():
	if Input.is_action_just_pressed("slot_left"):
		Global.inv_current_slot = (Global.inv_current_slot - 1) % slots.size()
	if Input.is_action_just_pressed("slot_right"):
		Global.inv_current_slot = (Global.inv_current_slot + 1) % slots.size()
	
	update_infos()
	update_slot_textures()

func _on_inventory_ui_slot_mouse_entered(slot_index: int) -> void:
	Global.inv_current_slot = slot_index
	update_infos()

func update_slot_textures():
	for i in range(slots.size()):
		slots[i].get_node("TextureRect").texture = slot_textures["active"] if i == Global.inv_current_slot else slot_textures["base"]

func update_infos():
	if Global.inv_current_slot < Global.player_inventory.items.size() and Global.player_inventory.items[Global.inv_current_slot] != null:
		var item = Global.player_inventory.items[Global.inv_current_slot]
		$Infos/Texte.text = str(InventoryItem.InventoryItemType.find_key(item.type)) + "\n" + item.description
		$Infos.show()
		
		for j in range(info_panels.size()):
			info_panels[j].visible = (j == Global.inv_current_slot)
	else:
		$Infos.hide()
