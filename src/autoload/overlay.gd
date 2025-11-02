extends Control

func _ready():
	$FadeRect.color.a = 0.0
	$Nausea.modulate.a = 0.0

var fadeTween: Tween
func fade_to_black(time:float):
	if time <= 0:
		$FadeRect.color.a = 1.0
		fadeTween = null
	else:
		fadeTween = get_tree().create_tween()
		fadeTween.tween_property(
			$FadeRect,
			"color:a",
			1.0,
			time
		)
		await fadeTween.finished
	return

func fade_from_black(time:float) -> void:
	if time <= 0:
		$FadeRect.color.a = 0.0
		fadeTween = null
	else:
		fadeTween = get_tree().create_tween()
		fadeTween.tween_property(
			$FadeRect,
			"color:a",
			0.0,
			time
		)
		await fadeTween.finished
		
	return 

var nausea_tween: Tween

func start_nausea() -> void:
	var shader = $Nausea.material
	if shader == null:
		return
	if nausea_tween:
		nausea_tween.kill()
	nausea_tween = get_tree().create_tween()
	nausea_tween.tween_property($Nausea, "modulate:a", 1.0, 0.5)
	nausea_tween.tween_property($Nausea.material, "shader_parameter/strength", 1.0, 1.0)
	print("J'ai la nausée")
	$Nausea.show()

func stop_nausea():
	var shader = $Nausea.material
	if shader == null:
		return
	if nausea_tween:
		nausea_tween.kill()
	nausea_tween = get_tree().create_tween()
	nausea_tween.tween_property($Nausea.material, "shader_parameter/strength", 0.0, 1.0)
	nausea_tween.parallel().tween_property($Nausea, "modulate:a", 0.0, 0.5)
	print("J'ai plus la nausée")
	nausea_tween.tween_callback(Callable($Nausea, "hide"))
