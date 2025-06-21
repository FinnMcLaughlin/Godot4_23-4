extends State
class_name TravelMoving

@onready var travel_state_machine: Node = $".."
@onready var travel_demo: TravelDemo = $"../.."

func enter(params : Dictionary = {}):
	print("Entering State --- " + "TravelMoving")
	_travel()
	
func _travel():
	travel_demo.ROUND_COUNT += 1
	
	print("Travel Round " + str(travel_demo.ROUND_COUNT))
	
	travel_demo.CUR_POS += travel_demo.BASE_DIST * travel_demo.SPEED
	
	_update_dist_to()
	
	print("Current: " + str(travel_demo.CUR_POS) + " | Dest: " + str(travel_demo.DIST_TO))
	
	print("---------------")
	
	await get_tree().create_timer(0.25).timeout
	
	Transitioned.emit(travel_state_machine.current_state, "Damage")

func _update_dist_to():
	travel_demo.dist_to_label.text = travel_demo.dis_to_label_text + " " + str(travel_demo.DIST_TO - travel_demo.CUR_POS)
