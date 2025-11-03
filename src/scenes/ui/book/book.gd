extends Control

var current_page : int = 0
var taches : Array[Array] = [
	[Vector4(771.0, 303.0, 0.54, 0.746), Vector4(733.0, 327.0, 0.805, 1.0), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(747.0, 278.938, 0.52, 0.809), Vector4(760.0, 304.0, 0.652, 0.904), Vector4(732.0, 330.0, 0.723, 0.884)],
	[Vector4(781.0, 278.0, 0.586, 0.809), Vector4(684.0, 303.0, 0.873, 0.904), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(719.0, 277.0, 0.586, 0.809), Vector4(-1.0, -1.0, -1.0, -1.0), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(700.0, 315.0, 0.479, 0.755), Vector4(797.0, 316.0, 0.619, 0.898), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(689.0, 315.0, 0.479, 0.755), Vector4(762.0, 316.0, 0.505, 0.898), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(-1.0, -1.0, -1.0, -1.0), Vector4(-1.0, -1.0, -1.0, -1.0), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(638.0, 300.0, 0.68, 0.898), Vector4(784.0, 327.0, 0.708, 0.755), Vector4(-1.0, -1.0, -1.0, -1.0)],
	[Vector4(738.0, 274.0, 0.68, 0.898), Vector4(-1.0, -1.0, -1.0, -1.0), Vector4(-1.0, -1.0, -1.0, -1.0)]
	
]

@onready var taches_ui := get_tree().get_nodes_in_group("taches")

var hmm = preload("res://assets/graphical/ui/hmmmm.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	
	for p in range(Global.all_plantes.size()):
		Global.herbier.append(load(Global.all_plantes[p]))
		
	show_book()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_page == 0:
		$pred.disabled = true
	else:
		$pred.disabled = false
		
	if current_page == 8:
		$suivant.disabled = true
	else:
		$suivant.disabled = false
	pass

func show_book():
	remplir_le_bouquin(Global.herbier,$gauche/gauche_texture,$gauche/gauche_titre,$gauche/gauche_texte,$droite/droite_texture,$droite/droite_titre,$droite/droite_texte,current_page)

func current_index_not_empty(book: Array, i: int) -> bool:
	return i >= 0 and i < book.size() and book[i] != null

func remplir_page_plante(book: Array, i: int, tex: TextureRect, titre: RichTextLabel, texte: RichTextLabel):
	if current_index_not_empty(book, i):
		var plante = book[i]
		if plante.decouvert:
			tex.texture = plante.texture
			titre.text = str(Plante.PlanteType.find_key(plante.type))
		else:
			tex.texture = hmm
			titre.text = "???"
		texte.text = plante.description
	else:
		tex.texture = null
		titre.text = ""
		texte.text = ""

func remplir_page_item(book: Array, i: int, tex: TextureRect, titre: RichTextLabel, texte: RichTextLabel):
	if current_index_not_empty(book, i):
		var plante = book[i]
		var item = plante.item
		if item != null:
			if plante.decouvert:
				tex.texture = item.texture
				titre.text = str(InventoryItem.InventoryItemType.find_key(item.type))
			else:
				tex.texture = hmm
				titre.text = "???"
			#if plante.type != Plante.PlanteType.LAVANDES or plante.decouvert:
				#titre.text = str(InventoryItem.InventoryItemType.find_key(item.type))
			#else:
				#titre.text = "???"
			texte.text = item.description
		else:
			tex.texture = null
			titre.text = ""
			texte.text = ""
	else:
		tex.texture = null
		titre.text = ""
		texte.text = ""

func remplir_le_bouquin(
	book: Array,
	g: TextureRect, gtitre: RichTextLabel, gt: RichTextLabel,
	d: TextureRect, dtitre: RichTextLabel, dt: RichTextLabel,
	page: int
):
	remplir_page_plante(book, page, g, gtitre, gt)
	remplir_page_item(book, page, d, dtitre, dt)
	for i in range(taches_ui.size()-1):
		if taches[page][i] != Vector4(-1.0, -1.0, -1.0, -1.0):
			taches_ui[i].global_position = Vector2(taches[page][i].x, taches[page][i].y)
			taches_ui[i].scale = Vector2(taches[page][i].z, taches[page][i].w)
		else:
			taches_ui[i].hide()

func _on_suivant_pressed() -> void:
	$turn.play()
	$AnimatedSprite2D.play("turn_right")
	$gauche.hide()
	$droite.hide()
	for t in taches_ui:
		t.hide()
	current_page+=1
	show_book()

func _on_retour_pressed() -> void:
	$close.play()
	self.hide()

func _on_precedent_pressed() -> void:
	$turn.play()
	$AnimatedSprite2D.play("turn_left")
	$gauche.hide()
	$droite.hide()
	for t in taches_ui:
		t.hide()
	current_page-=1
	show_book()

func _on_animated_sprite_2d_animation_finished() -> void:
	fade_in($gauche)
	fade_in($droite)
	for i in range(taches_ui.size()):
		if taches[current_page][i] != Vector4(-1.0, -1.0, -1.0, -1.0) and !Global.herbier[current_page].item.revele:
			taches_ui[i].show()


func fade_in(c: Control):
	c.modulate.a = 0.0
	c.show()
	var tween := create_tween()
	tween.tween_property(c, "modulate:a", 1.0, 0.3) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
