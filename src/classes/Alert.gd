extends RichTextLabel

class_name TextAlert

@export var speed : float = 0.005

func show_alert(texte: String):
	print("Affichage de l'alerte : ", texte)
	await show_text(texte)
	await get_tree().create_timer(2).timeout
	await fade_out()
	clean()
	#print("cleaned alert")
	
func clean():
	text = ""
	
func show_text(texte: String):
	await type_text(texte)
	
func type_text(texte: String):
	text = texte
	visible_characters = 0
	visible = true
	modulate.a = 1.0
	for i in range(texte.length()):
		visible_characters = i + 1
		await get_tree().create_timer(speed).timeout

func fade_out(duration := 0.2):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(Callable(self, "_on_fade_out_finished"))
	return tween.finished

func _on_fade_out_finished():
	visible = false

func _on_stack_item():
	show_alert("Ingrédient collecté !")

func _on_inventory_full():
	show_alert("Inventaire plein !")

func _on_wall_item_required(item):
	show_alert("Requis : "+item)

func _on_wall_removed():
	show_alert("Zone débloquée !")
