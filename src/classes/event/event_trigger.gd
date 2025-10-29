@tool
extends Area3D
class_name EventTrigger

@export var events : Array[Event]
@export var event_probabilities : Array[float] # Must be the same size as event

@export_storage var event_markers := {} #idk how to define a list with static typing and init it but it should be Array[EventMarker]
@export_storage var event_instance : Node

func _ready():
	if Engine.is_editor_hint():
		pass
	else : 
		_rebuild_marker_dict()
		var i = select_random_event_id()
		if(i < events.size()):
			print("Selected event : " + events[i].name)
			instantiate_event(events[i])
			

func _rebuild_marker_dict():
	print("Rebuilding event_markers dictionary at runtime...")
	var new_map = {}
	for child in get_children():
		if child is EventMarker and child.linked_event:
			new_map[child.linked_event] = child
	event_markers = new_map
	print("Event markers rebuilt:", event_markers)

func _process(_delta):
	if Engine.is_editor_hint():
		_sync_markers()
		
func instantiate_event(event : Event):
	
	if event_instance : 
		event_instance.queue_free()

	event_instance = event.scene.instantiate()

	for child : Node3D in event_markers[event].get_children() : 
		var duplicate_child = child.duplicate()
		event_instance.add_child(duplicate_child)
	
	event_instance.event_finished.connect(select_new_event) 
	
	add_child(event_instance)
	event_instance.global_position = event.initial_position

func select_new_event():
	if event_instance : 
		event_instance.queue_free()
	print("Event finished")
	
	# TODO : Add cooldown
	
	var i = select_random_event_id()
	if(i < events.size()):
		print("Selected event : " + events[i].name)
		instantiate_event(events[i])

func _sync_markers():
	# Make sure every event has a marker linked to it
	for i in range(events.size()):
		var event = events[i]
		
		if not event_markers.has(event):
			var marker = _create_marker_for_event(event)
			print("Event marker 2 : " , marker)
			print("Event markers before : " , event_markers)
			event_markers[event] = marker
			print("Event marker 3 : " , event_markers[event])
			
	# Empty the removed markers
	var keys = event_markers.keys()
	for event in keys:
		if not events.has(event):
			var marker = event_markers[event]
			if is_instance_valid(marker):
				marker.queue_free()
			event_markers.erase(event)

func _create_marker_for_event(event: Event) -> EventMarker:
	event.initial_position = Vector3(0,0,0) #reset pos when you make a new marker
	var marker = EventMarker.new()
	marker.name = "EventMarker_%s" % event.name
	print("Event Marker 1 : " , marker)
	marker.linked_event = event
	marker.transform.origin = event.initial_position
	add_child(marker)
	
	marker.owner = get_owner() #makes it editable its kinda sick
	
	return marker

func _on_body_entered(body: Node3D) -> void:
	print("Body entered " + str(body.name))
	print("Event instance in body enter : " , event_instance)
	if body.transform :
		event_instance.event_triggered(body.position)

func select_random_event_id():
	var rand = randf()  # between 0 and 1
	var current_score = 0
	for i in range(len(event_probabilities)) : 
		current_score += event_probabilities[i]
		if rand <= current_score : 
			return i
			
	return 0 # default
	
