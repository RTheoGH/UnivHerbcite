extends Control

var image: Texture2D
var nom : String = "allo"
var texte : String
@export var speed : float = 0.005

@onready var l1 : RichTextLabel = $RichTextLabel
@onready var l2 : RichTextLabel = $RichTextLabel2

func activate():
	$TextureRect2.texture = image
	show_text(nom,texte)
	
func clean():
	$TextureRect2.texture = null
	$RichTextLabel.text = ""
	$RichTextLabel2.text = ""
	
func show_text(p: String, t: String):
	await type_text(l1,p)
	await type_text(l2,t)
	
func type_text(label: RichTextLabel, s: String):
	label.text = s
	label.visible_characters = 0
	for i in range(texte.length()):
		label.visible_characters = i + 1
		await get_tree().create_timer(speed).timeout

@onready var tween:= get_tree().create_tween()

func fade_in(duration := 0.4):
	modulate.a = 0.0
	visible = true
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)
	
func fade_out(duration := 0.2):
	tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished():
	visible = false
