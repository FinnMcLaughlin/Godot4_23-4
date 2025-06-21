extends Node2D
class_name ToyotaTorino

@onready var ui_components : Array = $Panel/Components.get_children()

enum components {
	BATTERY,
	TIRES,
	RADIATOR,
	FUEL,
	FLOODLIGHTS
}

var t_speed = {
	"PACED" : 1,
	"CRUISING" : 1.75,
	"SPEEDING" : 2.5
}

var torino_data : Dictionary = {}

signal TakeDamage
signal FixComponent

signal ComponentBroken
signal ComponentWorking

signal TravelDamage
signal UpdateDash

func _ready() -> void:
	for c in components:
		torino_data[c] = _initialise_torino()
	
	_update_speed(t_speed.CRUISING)
	
	TakeDamage.connect(_take_dam)
	FixComponent.connect(_fix_comp)
	
	ComponentBroken.connect(_comp_broken)
	ComponentWorking.connect(_comp_working)
	
	UpdateDash.connect(_update_pb)
	TravelDamage.connect(_travel_damage)
	
	_update_pb()

func _process(delta: float) -> void:
	pass

func _initialise_torino():
	return {
		"working" : true,
		"condition" : 100,
		"quantity" : 1,
		"icon_sprite" : null
	}

func _take_dam(comp, dam : int):
	print(comp)
	print(dam)
	torino_data[comp].condition -= dam
	_update_pb()

func _fix_comp(comp, dam : int):
	torino_data[comp].condition += dam
	_update_pb()

func _comp_broken(comp):
	torino_data[comp].working = false

func _comp_working(comp):
	torino_data[comp].working = true

func _travel_damage():
	print("OW!")
	_take_dam(components.keys().pick_random(), (randi_range(0, 12) * torino_data["speed"]) * 0.7)

func _update_speed(sp):
	torino_data["speed"] = sp

func _update_pb():
	for pb in ui_components:
		pb.value = torino_data[pb.name.replace("PB_", "")].condition
