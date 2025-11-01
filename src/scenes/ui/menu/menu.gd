extends Control

const SCENEPATH = "res://src/scenes/tests/scene/Scene.tscn"

var transition_time := 1.9
@onready var backgrounds := Array(DirAccess.get_files_at("res://assets/graphical/background")).filter(func(elem: String): return !elem.contains(".import"))
var current_frame := 0

var loading := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(backgrounds)
	$fond.texture = load("res://assets/graphical/background/"+backgrounds[current_frame])
	#if current_frame != backgrounds.size()-1 : 
		#$fond.texture = load("res://ressources/background/"+backgrounds[current_frame+1])
	#else:
		#$fond.texture = load("res://ressources/background/"+backgrounds[0])
	$Propos.visible = false
	$Options.hide()
	$Chargement.hide()
	$chargement_block.hide()
	$Learn.hide()
	$Backgrounds.play("default")
	$fond.material.set_shader_parameter("progression",0)
	$BackgroundTimer.timeout.connect(
		func ():
			transition()
	)
	$Backgrounds.frame += 1
	pass # Replace with function body.

func transition() -> void:
	$fond2.texture = load("res://assets/graphical/background/"+backgrounds[(current_frame+1) % backgrounds.size()])
	
	var tween = get_tree().create_tween()
	
	# TODO HERE DEBILUS
	
	tween.tween_method(
		(func (val: float):
			$fond.material.set_shader_parameter("progression",val)
			)
		,
		0.0,
		1.1,
		transition_time
	)
	await tween.finished
	current_frame += 1
	$fond.texture = load("res://assets/graphical/background/"+backgrounds[current_frame % backgrounds.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var status := [0.0]
	
	if loading :
		ResourceLoader.load_threaded_get_status(SCENEPATH, status)
		if status[0] >= 0.9999:
			finalize_launch()
		elif status[0] >= 0.9:
			$chargement_block/texte.text = messages[2]
		elif status[0] >= 0.3:
			$chargement_block/texte.text = messages[1] + str(
				int(1238 * (status[0] - 0.3) / (0.9/0.3))
				) + " / " + str(1238)
		else:
			$chargement_block/texte.text = messages[0]


func _on_quitter_pressed() -> void:
	$sfx.play()
	get_tree().quit()

var cpt = 0
const messages = [
	"Chargement de la fac...",
	"Spawn des plantes...",
	"Lancement..."
]

func launch_hide() -> void:
	$plante.hide()
	$plante2.hide()
	$sous_menu.hide()
	$propos.hide()
	$titre.hide()

func _on_jouer_pressed() -> void:
	$sfx.play()
	$Learn.show()
	$Chargement.show()
	$chargement_block.show()
	launch_hide()
	loading = true
	ResourceLoader.load_threaded_request(SCENEPATH)
	#get_tree().change_scene_to_file("res://scenes/Scene.tscn")

func finalize_launch() -> void:
	loading = false
	$Chargement.hide()
	$chargement_block.hide()
	$plante.show()
	Overlay.fade_to_black(0)
	Overlay.fade_from_black(4.0)
	
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(SCENEPATH))


func _on_propos_pressed() -> void:
	$sfx.play()
	$Propos.visible = true


func _on_options_pressed() -> void:
	$sfx.play()
	$Options.show()
