extends State
class_name TravelIdle

@onready var travel_state_machine: Node = $".."
@onready var travel_demo: TravelDemo = $"../.."

func enter(params : Dictionary = {}):
	print("Entering State --- " + "TravelIdle")
	if travel_demo.CUR_POS < travel_demo.DIST_TO:
		await get_tree().create_timer(0.25).timeout
		Transitioned.emit(travel_state_machine.current_state, "Moving")
