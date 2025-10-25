extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var previous_mouse_pos:Vector2 = DisplayServer.window_get_size()/2
@onready var cam_fps: Node3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D

#@onready var item_frame: MeshInstance3D = $Camera3D/MeshInstance3D
@onready var item_frame: Sprite3D = $Camera3D/Sprite3D
var frame_pos: Vector3
@export var frame_timer: float = 0.0
@export var frame_amount: float = 0.05
@export var frame_speed: float = 10.0
var current_slot := -1

@onready var audio_marche : AudioStreamPlayer2D = $Marche
var step_timer: float = 0.0
var step_interval: float = 0.5

#var cam_speed = 0.5
var static_cam := false

var one_time: bool = false
var already_discovered: bool = false

var crosshair_textures = {
	"default": preload("res://assets/graphical/crosshair.png"),
	"pickup": preload("res://assets/graphical/crosshair_pickup.res"),
	"interact": preload("res://assets/graphical/crosshair_interact.res")
}

func try_grab() -> Node3D:
	var obj := ray.get_collider()
	if is_instance_of(obj, Interactable):
		obj.on_interaction()
		if !already_discovered:
			if obj.plante != null:
				$TextAlert.show_alert("Nouvelle plante découverte !")
				$Informations.nom = str(Plante.PlanteType.find_key(obj.plante.type))
				$Informations.image = obj.plante.texture
				$Informations.texte = obj.plante.description
				$Informations.activate()
		else:
			if Global.player_inventory.items.size() < 3:
				$TextAlert.show_alert("Ingrédient collecté !")
	return obj
	
func _ready() -> void:
	$Camera3D/RayCast3D.collide_with_areas = true
	$Camera3D/RayCast3D.collide_with_bodies = false
	$Informations.hide()
	
	item_frame.texture = null 
	frame_pos = item_frame.position

func _physics_process(delta: float) -> void:
	
	if Global.isPaused :
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		static_cam = true
		return
		
	if Global.is_inventory_open || Global.is_craft_ui_open:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: 
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	_update_item_frame()
	
	var cam_diff := Vector2.ZERO
	if !static_cam:
		cam_diff = get_viewport().get_mouse_position() - previous_mouse_pos
	
	if Input.is_action_just_pressed("scroll_down") and $Informations.visible:
		var scroll = $Informations/RichTextLabel2.get_v_scroll_bar()
		scroll.value += 20
		
	if Input.is_action_just_pressed("scroll_up") and $Informations.visible:
		var scroll = $Informations/RichTextLabel2.get_v_scroll_bar()
		scroll.value -= 20
	
	if Input.is_action_just_pressed("inv_slot_one") and !Global.isPaused:
		Global.inv_current_slot = 0
	if Input.is_action_just_pressed("inv_slot_two") and !Global.isPaused:
		Global.inv_current_slot = 1
	if Input.is_action_just_pressed("inv_slot_three") and !Global.isPaused:
		Global.inv_current_slot = 2
	
	var obj := ray.get_collider()
	if(is_instance_of(obj, Interactable)):
		if obj.is_collectible:
			#$Camera3D/Crosshair.texture = load("res://assets/graphical/crosshair_pickup.res")
			$Camera3D/Crosshair.texture = crosshair_textures["pickup"]
			if !one_time:
				one_time = true
				for h in Global.herbier:
					if h.type == obj.plante.type:
						already_discovered = true

				$Informations.fade_in()
				
				if already_discovered:
					$Informations.nom = str(Plante.PlanteType.find_key(obj.plante.type))
					$Informations.image = obj.plante.texture
					$Informations.texte = obj.plante.description
				else:
					$Informations.nom = "???"
					$Informations.image = load("res://assets/graphical/ui/hmmmm.png")
					$Informations.texte = "Vous n'avez pas encore découvert cette plante."
				$Informations.activate()
		else:
			#$Camera3D/Crosshair.texture = load("res://assets/graphical/crosshair_interact.res")
			$Camera3D/Crosshair.texture = crosshair_textures["interact"]
	else:
		#$Camera3D/Crosshair.texture = load("res://assets/graphical/crosshair.png")
		$Camera3D/Crosshair.texture = crosshair_textures["default"]
		$Informations.fade_out()
		one_time = false
		already_discovered = false
		$Informations.clean()
		
		Global.is_craft_ui_open = false
	
	if Input.is_action_just_pressed("grab") and !Global.isPaused and !Global.is_inventory_open and !Global.is_craft_ui_open:
		try_grab()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (cam_fps.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = -(direction.cross(Vector3.UP)).cross(Vector3.UP).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if !(Global.is_inventory_open || Global.is_craft_ui_open):
		if(rad_to_deg(cam_fps.global_rotation.x - cam_diff.y * delta * Global.cam_speed) < -80):
			cam_fps.global_rotation.x = deg_to_rad(-79.9)
		elif(rad_to_deg(cam_fps.global_rotation.x - cam_diff.y * delta * Global.cam_speed) > 80):
			cam_fps.global_rotation.x = deg_to_rad(80)
		else:
			cam_fps.global_rotation.x -= cam_diff.y * delta * Global.cam_speed

		
		cam_fps.global_rotation.y -= cam_diff.x * delta * Global.cam_speed
	
		if get_viewport().get_window().has_focus():
			Input.warp_mouse(DisplayServer.window_get_size()/2)
		else:
			static_cam = true
			return
	
	previous_mouse_pos = get_viewport().get_mouse_position()
	
	var h_speed = Vector2(velocity.x, velocity.z).length()
	if h_speed > 0.1 and is_on_floor():
		frame_timer += delta * frame_speed
		item_frame.position.y = frame_pos.y + sin(frame_timer) * frame_amount
	else:
		frame_timer = 0.0
		item_frame.position.y = lerp(item_frame.position.y, frame_pos.y, delta * 5)
	
	var is_moving = input_dir.length() > 0.1 and is_on_floor()
	if is_moving:
		step_timer -= delta
		if step_timer <= 0.0:
			if not audio_marche.playing:
				audio_marche.pitch_scale = randf_range(0.9,1.1)
				audio_marche.play()
			step_timer = step_interval
	else:
		step_timer = 0.0
		audio_marche.stop()
		
	static_cam = false
	move_and_slide()

func _update_item_frame():
	var slot = Global.inv_current_slot
	
	if slot < 0 or slot >= Global.player_inventory.items.size():
		current_slot = slot
		item_frame.texture = null
		return
	
	var tex = Global.player_inventory.items[slot].texture
	
	if slot != current_slot or item_frame.texture != tex:
		current_slot = slot
		item_frame.texture = tex
