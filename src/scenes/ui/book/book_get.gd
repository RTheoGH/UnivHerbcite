extends MeshInstance3D

func _ready() -> void:
	if $"Interactable":
		$Interactable.on_interaction_signal.connect(recup_herbier)

func recup_herbier():
	Global.book_not_collected = false
	Global.isPaused = true
	$"../Pause".show()
	$"../Pause/Book".show()
	Global.text_alert.show_alert("Herbier récupéré !")
	queue_free()
	
