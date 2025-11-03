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
var recipes_one_time := [false, false, false, false, false]
var narrate_craft := -1

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
	if Input.is_action_just_pressed("inventory") or Input.is_action_just_pressed("pause"):
		Global.is_craft_ui_open = false
		hide()
		
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
			var can_craft_item = false
			var count := 0
			for r in Global.recipes:
				if r.can_craft(ings):
					can_craft_item = true
					result = r.result
					if !recipes_one_time[count]:
						narrate_craft = count
						recipes_one_time[count] = true
				count+=1
					
			if can_craft_item:
				#$TextureRect2.texture = result.texture
				print("texture ?", result.texture)
				#$RichTextLabel.text = str(InventoryItem.InventoryItemType.find_key(result.type))
				#$TextureRect.texture = craft_ui_textures["complete"]
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
		for ci in current_ings:
			#var figue = InventoryItem.InventoryItemType.FIGUES
			#var myrobolan = InventoryItem.InventoryItemType.MYROBOLANS

			ci.revele = true
			var plant = Global.get_plant_from_item(ci)
			if plant:
				plant.decouvert = true
				Global.discoveries.append(plant)
		if $TextureRect.texture == craft_ui_textures["complete"]:
			$TextureRect.texture = craft_ui_textures["base"]
		refresh()
	else:
		Global.player_inventory.consume_items(current_ings)
		$Fail.play()
		$ColorRect4/RichTextLabel2.text = "[center]La fabrication n'a rien donné."
		refresh()

func _on_confirm_2_button_up() -> void:
	Global.is_craft_ui_open = false
	hide()
	result = null

func _on_visibility_changed() -> void:
	if visible:
		$ColorRect4/RichTextLabel2.text = ""
		refresh()
	elif narrate_craft >= 0:
		var craft_narration = {
			"[color=orange]Recette n°1 : L'aspergétique[/color]" : "Vous avez réussi votre première concoction ! [br]Les asperges poussent dans la terre et le bourgeon qui en sort s'appelle le turion. Il s'agit de la partie comestible de l'asperge et il est généralement récolté quand il mesure une vingtaine de centimètres.\
			[br]Le romarin est une plante dite mellifère : elle produit une bonne quantité de nectar et de pollen. Le miel de romarin (aussi appelé miel de Narbonne) est produit depuis le Moyen-Âge au XIIème siècle dans le sud de la France. [br]\
			Le lierre est une plante grimpante qui, malgré les idées recues, ne se nourrit pas de la sève des arbres mais de l'eau et des sels minéraux par ses racines. Cherchant la photosynthèse, elles s'accrochent aux arbres pour accéder à la lumière du soleil mais ne sont pas assez lourdes pour enserrer l'arbre."
			,
			"[color=orange]Recette n°2 : le désherbant[/color]" : "Vous avez concocté un désherbant ![br]\
			À l'instar du romarin, la lavande est une plante mellifère qui est donc très prisée des abeilles.[br]\
			Le myrobolan, ou prunier-cerise, est un arbre d'Europe du Sud-Est et d'Asie du Sud-Ouest ensuite introduit en France. Il donne une drupe (fruit charnue avec un noyau) semblable à une mirabelle et qui peut être de différentes couleurs. Ce fruit peut être très apprécié par certains animaux, notamment les oiseaux et les écureuils.[br]\
			Arbre caractéristique de la méditérranée, l'olivier produit lui aussi une drupe, l'olive, qui est vastement utilisée dans bon nombre de plats, que ce soit sous forme d'huile, de tapenade, de sauce, etc."
			,
			"[color=orange]Recette n°3 : l'acide[/color]" : "Vous avez obtenu un acide puissant ![br]\
			Vous avez reussi à comprendre les indices laissés sur les arbres.[br]\
			La sève de la figue a des composés irritants pouvant provoquer des brûlures.[br]\
			L'arbouse signifie le 'fruit que l'on de mange qu'une fois'.[br]\
			Cet acide peut ronger n'importe quels métaux."
			,
			"[color=orange]Recette n°4 : le désintoxifiant[/color]" : "Vous avez obtenu un désintoxifiant ![br]\
			Vous avez compris les instructions du scientifique dans le laboratoire.\
			La jujube et l'olive possèdent des propriétés antioxydants."
			,
			"[color=orange]Recette n°5 : le breuvage[/color]" : "Vous avez obtenu un étrange breuvage bleu ![br]\
			Mais à quoi sert donc cette potion ?"
		}
		var key = craft_narration.keys()[narrate_craft]
		Global.narrate(key, craft_narration[key])
		narrate_craft = -1

func _on_interactable_crafting_opened() -> void:
	show()
	Global.is_craft_ui_open = true
	print(Global.player_inventory.items)


func _on_interactable_area_exited(area: Area3D) -> void:
	if is_instance_of(area.get_parent(), RayCast3D):
		hide()
		Global.is_craft_ui_open = false


func _on_place_mouse_entered(place: int) -> void:
	if place == 0:
		$ColorRect4/RichTextLabel2.text = "[center]Broyer"
	if place == 1:
		$ColorRect4/RichTextLabel2.text = "[center]Infuser"
	if place == 2:
		$ColorRect4/RichTextLabel2.text = "[center]Sécher"


func _on_place_mouse_exited() -> void:
	$ColorRect4/RichTextLabel2.text = ""
