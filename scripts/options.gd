extends Control

var forward_key = ""
var backward_key = ""
var left_key = ""
var right_key = ""

var modif := ""
var current_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.volume_db = Global.ui_volume
	$modifier.hide()
	get_movements_keys()
	$sensi/sensi_val.text = str(Global.cam_speed)
	$musique/musique_val.text = str(Global.music_volume)
	$menu/menu_val.text = str(Global.ui_volume)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AudioStreamPlayer2D.volume_db = Global.ui_volume
	set_camera_speed()
	set_music_volume()
	set_ui_volume()
	if(!Global.minimap_activated):
		$form_minimap.hide()
		$form_minimap_text.hide()
	else:
		$form_minimap.show()
		$form_minimap_text.show()
	pass
	
func set_camera_speed():
	var cam_slider = $sensi/sensi_slider.value
	Global.cam_speed = cam_slider/100
	$sensi/sensi_val.text = str(Global.cam_speed)
	
func set_music_volume():
	var volume_m_slider = $musique/musique_slider.value
	Global.music_volume = linear_to_db(volume_m_slider)
	$musique/musique_val.text = str(volume_m_slider*100)
	
func set_ui_volume():
	var volume_ui_slider = $menu/menu_slider.value
	Global.ui_volume = linear_to_db(volume_ui_slider)
	$menu/menu_val.text = str(volume_ui_slider*100)

func _on_retour_pressed() -> void:
	$AudioStreamPlayer2D.play()
	self.hide()
	
func get_movements_keys() -> void:
	
	$Button.text = eng_to_fr(InputMap.action_get_events("forward")[0].as_text())
	$Button2.text = eng_to_fr(InputMap.action_get_events("backward")[0].as_text())
	$Button3.text = eng_to_fr(InputMap.action_get_events("left")[0].as_text())
	$Button4.text = eng_to_fr(InputMap.action_get_events("right")[0].as_text())
	$Button5.text = eng_to_fr(InputMap.action_get_events("jump")[0].as_text())
	
func eng_to_fr(s):
	match s:
		'W (Physical)':
			s = 'Z'
		'A (Physical)':
			s = 'Q'
		'S (Physical)':
			s = 'S'
		'D (Physical)':
			s = 'D'
		'Space', 'Space (Physical)':
			s = 'Espace'
		_:
			s = '???'
	return s
	
func _input(event):
	if modif != "" and event is InputEventKey and event.pressed:
		print(event,"\n",current_button)
		if event.keycode != KEY_ESCAPE:
			InputMap.action_erase_events(modif)
			InputMap.action_add_event(modif,event)
			if event.keycode != KEY_SPACE:
				current_button.text = event.as_text()
			else:
				current_button.text = eng_to_fr(event.as_text())
		$modifier.hide()
		modif = ""

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.play()
	modif = "forward"
	current_button = $Button
	$modifier.show()

func _on_button_2_pressed() -> void:
	$AudioStreamPlayer2D.play()
	modif = "backward"
	current_button = $Button2
	$modifier.show()

func _on_button_3_pressed() -> void:
	$AudioStreamPlayer2D.play()
	modif = "left"
	current_button = $Button3
	$modifier.show()

func _on_button_4_pressed() -> void:
	$AudioStreamPlayer2D.play()
	modif = "right"
	current_button = $Button4
	$modifier.show()
	
func _on_button_5_pressed() -> void:
	$AudioStreamPlayer2D.play()
	modif = "jump"
	current_button = $Button5
	$modifier.show()

func _on_minimap_pressed() -> void:
	Global.minimap_activated = !Global.minimap_activated
	print(Global.minimap_activated)

func _on_form_minimap_pressed() -> void:
	Global.carre_minimap = !Global.carre_minimap
	print(Global.carre_minimap)
