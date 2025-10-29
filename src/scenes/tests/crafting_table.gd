extends Interactable

class_name Crafting_table

signal crafting_opened

func on_interaction():
	Global.is_craft_ui_open = true
	crafting_opened.emit()
