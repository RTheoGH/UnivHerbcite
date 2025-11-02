extends Control

var forward_key = ""
var backward_key = ""
var left_key = ""
var right_key = ""

var modif := ""
var current_button : Button

var master = AudioServer.get_bus_index("Master")
var music = AudioServer.get_bus_index("Music")
var sfx = AudioServer.get_bus_index("SFX")



func _ready() -> void:
	$modifier.hide()
	get_movements_keys()
	$global/global_val.text = str(AudioServer.get_bus_volume_linear(master))
	$musique/musique_val.text = str(AudioServer.get_bus_volume_linear(music))
	$menu/menu_val.text = str(AudioServer.get_bus_volume_linear(sfx))
	$AA_option.selected = 1
	$Ombres_option.selected = 3
	$Guide_b.button_pressed = true
	$LOD_b.button_pressed = true

func _process(_delta: float) -> void:
	set_camera_speed()
	set_global_volume()
	set_music_volume()
	set_ui_volume()

	if(!Global.minimap_activated):
		$form_minimap.hide()
		$form_minimap_text.hide()
	else:
		$form_minimap.show()
		$form_minimap_text.show()
	pass
	
# --------------- SLIDERS ---------------

func set_camera_speed():
	var cam_slider = $sensi/sensi_slider.value
	Global.cam_speed = cam_slider/100
	$sensi/sensi_val.text = str(Global.cam_speed)

func set_global_volume():
	var volume_global_slider = $global/global_slider.value
	AudioServer.set_bus_volume_linear(master, volume_global_slider)
	$global/global_val.text = str(int(volume_global_slider*100))

func set_music_volume():
	var volume_m_slider = $musique/musique_slider.value
	AudioServer.set_bus_volume_linear(music, volume_m_slider)
	$musique/musique_val.text = str(int(volume_m_slider*100))

func set_ui_volume():
	var volume_sfx_slider = $menu/menu_slider.value
	AudioServer.set_bus_volume_linear(sfx, volume_sfx_slider)
	$menu/menu_val.text = str(int(volume_sfx_slider*100))

# ----------------------------------------

func _on_retour_pressed() -> void:
	$sfx.play()
	self.hide()

func get_movements_keys() -> void:
	$Avancer_B.text = eng_to_fr(InputMap.action_get_events("forward")[0].as_text())
	$Reculer_B.text = eng_to_fr(InputMap.action_get_events("backward")[0].as_text())
	$Gauche_B.text = eng_to_fr(InputMap.action_get_events("left")[0].as_text())
	$Droite_B.text = eng_to_fr(InputMap.action_get_events("right")[0].as_text())
	$Sauter_B.text = eng_to_fr(InputMap.action_get_events("jump")[0].as_text())
	$Grab_B.text = eng_to_fr(InputMap.action_get_events("grab")[0].as_text())
	$Livre_B.text = eng_to_fr(InputMap.action_get_events("ouvrir_livre")[0].as_text())
	$SlotG_B.text = eng_to_fr(InputMap.action_get_events("slot_left")[0].as_text())
	$SlotD_B.text = eng_to_fr(InputMap.action_get_events("slot_right")[0].as_text())
	$Slot0_B.text = eng_to_fr(InputMap.action_get_events("inv_slot_one")[0].as_text())
	$Slot1_B.text = eng_to_fr(InputMap.action_get_events("inv_slot_two")[0].as_text())
	$Slot2_B.text = eng_to_fr(InputMap.action_get_events("inv_slot_three")[0].as_text())
	$Slot2_B.text = eng_to_fr(InputMap.action_get_events("inv_slot_three")[0].as_text())
	$Inventaire_B.text = eng_to_fr(InputMap.action_get_events("inventory")[0].as_text())

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
		'Tab (Physical)':
			s = 'Tab'
		'Right (Physical)':
			s = 'Droite'
		'Left (Physical)':
			s = 'Gauche'
		'Left Mouse Button':
			s = 'Clic gauche'
		'1 (Physical)':
			s = '1'
		'2 (Physical)':
			s = '2'
		'3 (Physical)':
			s = '3'
		'E (Physical)':
			s = 'E'
		_:
			s = '???'
	return s

func mouse_index_to_text(s):
	match s:
		1:
			s = 'Clic gauche'
		2:
			s = 'Clic droit'
		3:
			s = 'Clic molette'
		4:
			s = 'Défil haut'
		5:
			s = 'Défil bas'
			
	return s

func _input(event):
	if modif != "" and event is not InputEventMouseMotion:
		#print(event,"\n",current_button)
		if event is InputEventKey and event.pressed:
			if event.keycode != KEY_ESCAPE:
					InputMap.action_erase_events(modif)
					InputMap.action_add_event(modif,event)
					if event.keycode != KEY_SPACE:
						current_button.text = event.as_text()
					else:
						current_button.text = eng_to_fr(event.as_text())
		if event is InputEventMouseButton:
			InputMap.action_erase_events(modif)
			InputMap.action_add_event(modif,event)
			current_button.text = mouse_index_to_text(event.button_index)
		current_button.tooltip_text = current_button.text 
		$modifier.hide()
		modif = ""

func _on_avancer_pressed() -> void:
	$sfx.play()
	modif = "forward"
	current_button = $Avancer_B
	$modifier.show()

func _on_reculer_pressed() -> void:
	$sfx.play()
	modif = "backward"
	current_button = $Reculer_B
	$modifier.show()

func _on_gauche_pressed() -> void:
	$sfx.play()
	modif = "left"
	current_button = $Gauche_B
	$modifier.show()

func _on_droite_pressed() -> void:
	$sfx.play()
	modif = "right"
	current_button = $Droite_B
	$modifier.show()
	
func _on_sauter_pressed() -> void:
	$sfx.play()
	modif = "jump"
	current_button = $Sauter_B
	$modifier.show()

func _on_grab_pressed() -> void:
	$sfx.play()
	modif = "grab"
	current_button = $Grab_B
	$modifier.show()

func _on_livre_pressed() -> void:
	$sfx.play()
	modif = "ouvrir_livre"
	current_button = $Livre_B
	$modifier.show()

func _on_slotG_pressed() -> void:
	$sfx.play()
	modif = "slot_left"
	current_button = $SlotG_B
	$modifier.show()

func _on_slotD_pressed() -> void:
	$sfx.play()
	modif = "slot_right"
	current_button = $SlotD_B
	$modifier.show()

func _on_minimap_pressed() -> void:
	$sfx.play()
	Global.minimap_activated = !Global.minimap_activated

func _on_form_minimap_pressed() -> void:
	$sfx.play()
	Global.carre_minimap = !Global.carre_minimap

func _on_sensi_slider_drag_started() -> void:
	$sfx.play()

func _on_global_slider_drag_started() -> void:
	$sfx.play()

func _on_musique_slider_drag_started() -> void:
	$sfx.play()

func _on_menu_slider_drag_started() -> void:
	$sfx.play()

func _on_slot_0_pressed() -> void:
	$sfx.play()
	modif = "inv_slot_one"
	current_button = $Slot0_B
	$modifier.show()

func _on_slot_1_pressed() -> void:
	$sfx.play()
	modif = "inv_slot_two"
	current_button = $Slot1_B
	$modifier.show()

func _on_slot_2_pressed() -> void:
	$sfx.play()
	modif = "inv_slot_three"
	current_button = $Slot2_B
	$modifier.show()

func _on_option_button_item_selected(index: int) -> void:
	var vwp := get_viewport()
	match index:
		0: vwp.msaa_3d = Viewport.MSAA_DISABLED
		1: vwp.msaa_3d = Viewport.MSAA_2X
		2: vwp.msaa_3d = Viewport.MSAA_4X
		3: vwp.msaa_3d = Viewport.MSAA_8X

func _on_fps_b_pressed() -> void:
	Global.fps = !Global.fps

func _on_guide_b_pressed() -> void:
	Global.guidage = !Global.guidage


func _on_inventaire_b_pressed() -> void:
	$sfx.play()
	modif = "inventory"
	current_button = $Inventaire_B
	$modifier.show()

func _on_lod_b_pressed() -> void:
	Global.lod_distance = !Global.lod_distance

func _on_ombres_option_item_selected(index: int) -> void:
	var PS := ProjectSettings
	match index:
		0: PS.set_setting("rendering/quality/shadows/filter_mode", 0)
		1: PS.set_setting("rendering/quality/shadows/filter_mode", 1)
		2: PS.set_setting("rendering/quality/shadows/filter_mode", 2)
		3: PS.set_setting("rendering/quality/shadows/filter_mode", 3)
		4: PS.set_setting("rendering/quality/shadows/filter_mode", 4)
		5: PS.set_setting("rendering/quality/shadows/filter_mode", 5)
