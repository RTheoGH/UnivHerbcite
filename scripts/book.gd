extends Control

var current_page : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$turn.volume_db = Global.ui_volume
	$close.volume_db = Global.ui_volume
	$AnimatedSprite2D.play("default")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$turn.volume_db = Global.ui_volume
	$close.volume_db = Global.ui_volume
	if current_page == 0:
		$pred.disabled = true
	else:
		$pred.disabled = false
		
	if current_page == 4:
		$suivant.disabled = true
	else:
		$suivant.disabled = false
	pass
	
	remplir_le_bouquin(Global.herbier,$gauche/gauche_texture,$gauche/gauche_texte,$droite/droite_texture,$droite/droite_texte,current_page)

func current_index_not_empty(book:Array,i: int):
	return i >= 0 and i < book.size() and book[i] != null

func remplir_pages(book:Array,i:int,tex:TextureRect,texte:RichTextLabel):
		if current_index_not_empty(book,i):
			tex.texture = book[i].texture
			texte.text = book[i].description
		else:
			tex.texture = null
			texte.text = ""

func remplir_le_bouquin(book: Array,g: TextureRect,gt: RichTextLabel,d: TextureRect,dt: RichTextLabel,page: int):
	var li = page * 2
	var ri = page * 2 + 1
	
	remplir_pages(book,li,g,gt)
	remplir_pages(book,ri,d,dt)

func _on_suivant_pressed() -> void:
	$turn.play()
	$AnimatedSprite2D.play("turn_right")
	$gauche.hide()
	$droite.hide()
	current_page+=1

func _on_retour_pressed() -> void:
	$close.play()
	self.hide()

func _on_precedent_pressed() -> void:
	$turn.play()
	$AnimatedSprite2D.play("turn_left")
	$gauche.hide()
	$droite.hide()
	current_page-=1

func _on_animated_sprite_2d_animation_finished() -> void:
	$gauche.show()
	$droite.show()
