extends Resource

class_name Inventory

@export var items : Array[InventoryItem]
@export var invSize : int
@export var stackSize : int

func add_item(item : InventoryItem):
	if items.has(item):
		# Make a stack system oops
		if item.quantity < stackSize:
			item.quantity += 1
		else :
			print( "You're carrying as many " + item.name + " as you can ! ")
			
	elif items.size() > invSize:
		print(" Your inventory is full ! ")
		# Discard an item ? 
	else : 
		items.push_back(item)
		if(!Global.herbier.has(item)):
			Global.herbier.push_back(item)
