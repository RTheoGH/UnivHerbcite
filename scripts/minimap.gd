extends Control

@export var player: Node3D
@onready var masque = $masque
@onready var container = $masque/Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	container.pivot_offset = masque.size * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player:
		return
		
	if(Global.carre_minimap):
		$contour.texture = load("res://ressources/ui/cadre2.png")
		$masque.texture = load("res://ressources/ui/cadre.png")
	else:
		$contour.texture = load("res://ressources/ui/cercle2.png")
		$masque.texture = load("res://ressources/ui/cercle.png")
	
	var la_camera_du_player = player.get_node("Camera3D")
	container.position = -Vector2(player.global_position.x,player.global_position.y)*100
	container.rotation = -la_camera_du_player.rotation.y
