extends Panel

@onready var item_display : TextureRect = $item_display
@onready var item_quantity_text : RichTextLabel = $item_quantity

func update_inventory_visual(item : InventoryItem):
	if(!item):
		item_display.visible = false
		item_quantity_text.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture
		if(item.quantity > 1):
			item_quantity_text.visible = true
			item_quantity_text.text = str(item.quantity)
		
