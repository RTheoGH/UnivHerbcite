extends Control

func _ready():
	$FadeRect.color.a = 0.0

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

func fade_from_black(time:float):
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
