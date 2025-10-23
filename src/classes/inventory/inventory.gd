extends Resource

class_name Inventory

@export var items : Array[InventoryItem]
@export var invSize : int = 3
@export var stackSize : int

func add_item(item : InventoryItem):
	if items.has(item):
		# Make a stack system oops
		if item.quantity < stackSize:
			item.quantity += 1
		else :
			print( "You're carrying as many " + str(InventoryItem.InventoryItemType.find_key(item.type)) + " as you can ! ")
			
	elif items.size() > invSize:
		print(" Your inventory is full ! ")
		# Discard an item ? 
	else : 
		items.push_back(item)
		
func remove_item(item : InventoryItem):
	if items.has(item):
		item.quantity -= 1
		if item.quantity <= 0:
			items.erase(item)

func has(itemType : InventoryItem.InventoryItemType) -> bool:
	for i in items:
		if i.type == itemType:
			return true
	return false

func can_add_craft(ings : Array[InventoryItem]) -> bool:
	for ing in range(ings.size()):
		for i in range(items.size()):
			if ings[ing].type == items[i].type && items[i].quantity == 1:
				return true
	return false

func consume_items(ings : Array[InventoryItem]) -> void:
	for ing in ings:
		remove_item(ing)
