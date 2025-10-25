extends Resource

class_name Inventory

@export var items : Array[InventoryItem] = []
@export var invSize : int = 3
@export var stackSize : int

signal inventory_full

func add_item(item : InventoryItem):
	if items.has(item):
		# Make a stack system oops
		
		if item.quantity < stackSize:
			item.quantity += 1
			print("Quantity : ", item.quantity)
		else :
			print( "You're carrying as many " + str(InventoryItem.InventoryItemType.find_key(item.type)) + " as you can ! ")
	else:
		if items.size()+1 > invSize:
			print(" Your inventory is full ! ")
			inventory_full.emit()
			# Discard an item ? 
		else : 
			item.quantity = 1
			items.push_back(item)
		
func remove_item(item : InventoryItem):
	if items.has(item):
		item.quantity -= 1
		if item.quantity <= 0:
			item.quantity = 0
			items.erase(item)
			
func remove_item_type(item_type : InventoryItem.InventoryItemType):
	var index = has(item_type)
	if index != -1:
		items.remove_at(index)

func has(item_type : InventoryItem.InventoryItemType) -> int:
	for i in range(items.size()):
		if items[i].type == item_type:
			return i
	return -1

func can_add_craft(ings : Array[InventoryItem]) -> bool:
	for ing in range(ings.size()):
		for i in range(items.size()):
			if ings[ing].type == items[i].type && items[i].quantity == 1:
				return true
	return false

func consume_items(ings : Array[InventoryItem]) -> void:
	for ing in ings:
		remove_item(ing)
