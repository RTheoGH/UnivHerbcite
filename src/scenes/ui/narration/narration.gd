extends Control

var tween: Tween
var typing_tween: Tween

@onready var titre_label = $titre
@onready var contenu_label = $contenu

func _ready() -> void:
	hide()
	Global.narration_ui = self
	#set_narration("Le réveil", "Je me suis reveillé à l'universite. J'ai l'impression d'être au S-pace mais quelque chose est étrange...")

func set_narration(title: String, contenu: String):
	Global.is_narration_showing = true
	$AudioStreamPlayer2D.play()
	if !Global.isPaused:
		Global.isPaused = true
	titre_label.text = title
	_contenu_typewriter(contenu)

func _contenu_typewriter(text: String, speed := 0.01):
	if typing_tween:
		typing_tween.kill()

	contenu_label.text = ""
	typing_tween = create_tween()
	typing_tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	for c in text:
		typing_tween.tween_callback(func ():
			contenu_label.text += c
		).set_delay(speed)

func fade_in(duration := 0.2):
	
	if tween:
		tween.kill()
	modulate.a = 0.0
	show()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)
	await tween.finished
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func fade_out(duration := 0.2):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(Callable(self, "_on_fade_out_finished"))

func _on_fade_out_finished():
	hide()

func _on_button_pressed() -> void:
	fade_out()
	if Global.isPaused:
		Global.isPaused = false
	Global.is_narration_showing = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
