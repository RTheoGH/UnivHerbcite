extends Control

var current_page : int = 0
var taches : Array[Vector4]

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
		
	if current_page == 10:
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
		else:
			tex.texture = load("res://assets/graphical/ui/hmmmm.png")
		titre.text = str(Plante.PlanteType.find_key(plante.type))
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
			else:
				tex.texture = load("res://assets/graphical/ui/hmmmm.png")
			if plante.type != Plante.PlanteType.LAVANDES or plante.decouvert:
				titre.text = str(InventoryItem.InventoryItemType.find_key(item.type))
			else:
				titre.text = "???"
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


func _on_suivant_pressed() -> void:
	$turn.play()
	$AnimatedSprite2D.play("turn_right")
	$gauche.hide()
	$droite.hide()
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
	current_page-=1
	show_book()

func _on_animated_sprite_2d_animation_finished() -> void:
	fade_in($gauche)
	fade_in($droite)

func fade_in(c: Control):
	c.modulate.a = 0.0
	c.show()
	var tween := create_tween()
	tween.tween_property(c, "modulate:a", 1.0, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
