@tool
extends Sprite3D
class_name MultiSprite3D

@export var sprites: Array[Texture]
@export var offsets: Array[Vector2]

@export var billboarding: bool:
	set(v):
		billboarding = v
		if (billboarding):
			billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		else:
			billboard = BaseMaterial3D.BILLBOARD_DISABLED

@export var texture_index_override: int = -1
func _ready() -> void:
	offsets.resize(sprites.size())
	if (billboarding):
		billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	else:
		billboard = BaseMaterial3D.BILLBOARD_DISABLED

func _process(delta: float) -> void:
	if not Engine.is_editor_hint() or texture_index_override <= 0 or texture_index_override >= sprites.size():
		var cam_forward: Vector3 = get_viewport().get_camera_3d().global_position - global_position
		
		var forwardVector: Vector3 = -global_basis.z
		
		cam_forward.y = 0
		forwardVector.y = 0
	
		var angle: float = cam_forward.signed_angle_to(forwardVector, Vector3.UP)
		if angle < 0: angle = 2 * PI + angle  #true modulo
		
		var index: int = angle / (2 * PI) * sprites.size(); # small factor to not floor too high
		
		
		texture = sprites[index]
		offset = offsets[index]
		
		print(index)
		
	else:
		texture = sprites[texture_index_override]
		offset = offsets[texture_index_override]
