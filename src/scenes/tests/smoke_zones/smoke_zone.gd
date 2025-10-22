extends Interactable

@export var required_item: InventoryItem.InventoryItemType
@export var smoke_color: Color

func _ready() -> void:
	$Area3D/GPUParticles3D.amount = 120
	$Area3D/GPUParticles3D.draw_pass_1.material.set_shader_parameter("Smoke_Color", smoke_color)

func on_interaction():
	if Global.player_inventory.has(required_item):
		queue_free()
		#emit_signal("revele_la_zone",required_item)
	else:
		print("Il vous faut un ", str(InventoryItem.InventoryItemType.find_key(required_item)), " pour pouvoir passer !")
