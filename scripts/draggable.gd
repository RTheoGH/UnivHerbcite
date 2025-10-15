extends Node2D

var body_place: Vector2
var is_inside_dropable := false
var is_mouse_inside := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_place = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if is_mouse_inside:
			if Input.is_action_pressed("left_click"):
					global_position = get_global_mouse_position()
			elif Input.is_action_just_released("left_click"):
				var tween = get_tree().create_tween()
				tween.tween_property(self, "global_position", body_place, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("droppable"):
		is_inside_dropable = true
		body_place = body.global_position

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("droppable"):
		is_inside_dropable = false


func _on_area_2d_mouse_entered() -> void:
	is_mouse_inside = true

func _on_area_2d_mouse_exited() -> void:
	is_mouse_inside = false
