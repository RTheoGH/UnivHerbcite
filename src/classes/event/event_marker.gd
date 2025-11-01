extends Marker3D

class_name EventMarker

@export var event_trigger : EventTrigger #not sure if usefull will see
@export var linked_event : Event

# update the event position if the tool is running
func _process(delta):
	if Engine.is_editor_hint() and linked_event:
		print("Marker pos : " , global_position)
		linked_event.initial_position = global_position
		print()
