extends State
class_name TravelEvent

@onready var travel_state_machine: Node = $".."
@onready var travel_demo: TravelDemo = $"../.."

var event_occurring : bool = false

func enter(params : Dictionary = {}):
	print("Entering State --- " + "TravelEvent")
	
	_event()

func update(delta):
	if event_occurring:
		if Input.is_action_just_released("click"):
			# await get_tree().create_timer(0.5).timeout
			travel_demo.event_manager._hide_event()
			Transitioned.emit(travel_state_machine.current_state, "Idle")

func _event():
	await travel_demo._random_event()
	event_occurring = true
		
