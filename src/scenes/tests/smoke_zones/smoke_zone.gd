extends Interactable

@export var required_item: InventoryItem.InventoryItemType
@export var smoke_color: Color

signal wall_item_required(item: String)
signal wall_removed

func _ready() -> void:
	$Area3D/GPUParticles3D.amount = 120
	$Area3D/GPUParticles3D.draw_pass_1.material.set_shader_parameter("Smoke_Color", smoke_color)
	add_to_group("walls")

func on_interaction():
	if Global.player_inventory.has(required_item) != -1:
		get_parent().get_node("Open").play()
		await get_tree().create_timer(1).timeout
		queue_free()
		Global.player_inventory.remove_item_type(required_item)
		wall_removed.emit()
	else:
		var item = str(InventoryItem.InventoryItemType.find_key(required_item))
		print("Il vous faut ", item, " pour pouvoir passer !")
		wall_item_required.emit(item)
