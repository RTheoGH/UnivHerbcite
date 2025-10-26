extends Control

var is_open = false
var chest_inventory : Inventory
var hoverred_slot : int = -1

func _ready() -> void:
	chest_inventory = Inventory.new()
	chest_inventory.invSize = 10


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory") or Input.is_action_just_pressed("pause"):
		hide()
	


func _on_interactable_chest_opened(inv: Inventory) -> void:
	show()
	is_open = true
	chest_inventory = inv
	Global.is_chest_open = true


func _on_area_exited(area: Area3D) -> void:
	if is_instance_of(area.get_parent(), RayCast3D):
		hide()
		is_open = false
		Global.is_chest_open = false


func _on_inventory_ui_slot_mouse_entered(index : int) -> void:
	hoverred_slot = index


func _on_inventory_ui_slot_mouse_exited() -> void:
	hoverred_slot = -1
