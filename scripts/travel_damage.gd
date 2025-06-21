extends State
class_name TravelDamage

@onready var torino: ToyotaTorino = $"../../Torino"
@onready var travel_demo: TravelDemo = $"../.."
@onready var travel_state_machine: Node = $".."

func enter(params : Dictionary = {}):
	print("Entering State --- " + "TravelDamage")
	
	if randi_range(0, 100) < 60:
		torino.TravelDamage.emit()
	
	await get_tree().create_timer(1).timeout
	
	var RE = randi_range(0, travel_demo.R_E_CH) * travel_demo.AREA_MOD * travel_demo.COND_MOD
	print("Random Encounter: " + str(RE) + " | Thresh: " + str(travel_demo.R_E_CH * 0.6))
	
	if (RE) > (travel_demo.R_E_CH * 0.6):
		Transitioned.emit(travel_state_machine.current_state, "Event")
	else:
		Transitioned.emit(travel_state_machine.current_state, "Idle")
