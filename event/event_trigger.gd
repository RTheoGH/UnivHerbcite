@tool
extends Area3D
class_name EventTrigger

@export var events : Array[Event]
@export var event_probabilities : Array[float] # Must be the same size as event

var event_markers := {} #idk how to define a list with static typing and int it but it should be Array[EventMarker]

func _ready():
	if Engine.is_editor_hint():
		_sync_markers()

func _process(_delta):
	if Engine.is_editor_hint():
		_sync_markers()

func _sync_markers():
	# Make sure every event has a marker linked to it
	for i in range(events.size()):
		var event = events[i]

		if event not in event_markers:
			var marker = _create_marker_for_event(event)
			event_markers[event] = marker

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
	marker.linked_event = event
	marker.transform.origin = event.initial_position
	add_child(marker)
	
	marker.owner = get_owner() #makes it editable its kinda sick
	return marker
