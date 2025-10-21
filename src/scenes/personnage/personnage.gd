extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var previous_mouse_pos:Vector2 = DisplayServer.window_get_size()/2
@onready var cam_fps: Node3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D
#var cam_speed = 0.5

var one_time: bool = false
var already_discovered: bool = false

func try_grab() -> Node3D:
	var obj := ray.get_collider()
	if is_instance_of(obj, Interactable):
		obj.on_interaction()
		if !already_discovered:
			$Informations.nom = str(InventoryItem.InventoryItemType.find_key(obj.item.type))
			$Informations.image = obj.item.texture
			$Informations.texte = obj.item.description
			$Informations.activate()
	return obj
	
func _ready() -> void:
	$Camera3D/RayCast3D.collide_with_areas = true
	$Camera3D/RayCast3D.collide_with_bodies = false
	$Informations.hide()

func _physics_process(delta: float) -> void:
	
	if Global.is_inventory_open || Global.isPaused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Global.isPaused : return
	else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	var cam_diff = get_viewport().get_mouse_position() - previous_mouse_pos
	
	if Input.is_action_just_pressed("scroll_down") and $Informations.visible:
		var scroll = $Informations/RichTextLabel2.get_v_scroll_bar()
		scroll.value += 20
		
	if Input.is_action_just_pressed("scroll_up") and $Informations.visible:
		var scroll = $Informations/RichTextLabel2.get_v_scroll_bar()
		scroll.value -= 20
	
	var obj := ray.get_collider()
	if(is_instance_of(obj, Interactable)):
		if obj.is_collectible:
			$Camera3D/Crosshair.texture = load("res://assets/graphical/crosshair_pickup.res")
			if !one_time:
				one_time = true
				#$Informations.visible = true
				print(Global.herbier)
				for h in Global.herbier:
					if h.type == obj.item.type:
						already_discovered = true

				$Informations.fade_in()
				
				if already_discovered:
					$Informations.nom = str(InventoryItem.InventoryItemType.find_key(obj.item.type))
					$Informations.image = obj.item.texture
					$Informations.texte = obj.item.description
				else:
					$Informations.nom = "???"
					$Informations.image = load("res://assets/graphical/ui/hmmmm.png")
					$Informations.texte = "Vous n'avez pas encore découvert cette plante."
				$Informations.activate()
		else:
			$Camera3D/Crosshair.texture = load("res://assets/graphical/crosshair_interact.res")
	else:
		$Camera3D/Crosshair.texture = load("res://assets/graphical/crosshair.png")
		#$Informations.visible = false
		$Informations.fade_out()
		one_time = false
		already_discovered = false
		$Informations.clean()
	
	if Input.is_action_just_pressed("grab") and !Global.isPaused:
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
		
	if !Global.is_inventory_open:
		if(rad_to_deg(cam_fps.global_rotation.x - cam_diff.y * delta * Global.cam_speed) < -80):
			cam_fps.global_rotation.x = deg_to_rad(-79.9)
		elif(rad_to_deg(cam_fps.global_rotation.x - cam_diff.y * delta * Global.cam_speed) > 80):
			cam_fps.global_rotation.x = deg_to_rad(80)
		else:
			cam_fps.global_rotation.x -= cam_diff.y * delta * Global.cam_speed

		
		cam_fps.global_rotation.y -= cam_diff.x * delta * Global.cam_speed
	
		if get_viewport().get_window().has_focus():
			Input.warp_mouse(DisplayServer.window_get_size()/2)
	
	previous_mouse_pos = get_viewport().get_mouse_position()

	#print(global_position)
	move_and_slide()
