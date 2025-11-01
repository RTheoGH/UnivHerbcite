extends Control

var one_time_narration := false

signal ui_opened

func _on_visibility_changed() -> void:
	if !visible and !one_time_narration:
		one_time_narration = true
		ui_opened.emit()

		
