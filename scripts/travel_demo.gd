extends Node2D
class_name TravelDemo

@onready var torino: ToyotaTorino = $Torino
@onready var event_manager: EventManager = $EventManager
@onready var event_node: Control = $EventManager/EventNode
@onready var dist_to_label: Label = $DistToLabel

@export var CUR_POS : int = 0
@export var DIST_TO : int
@export var TIMER : float

@export var BASE_DIST : int
@export var SPEED : float

@export var R_E_CH : float
@export var AREA_MOD : float
@export var COND_MOD : float

var ROUND_COUNT : int
var encounter_events : Dictionary

var event_occurring : bool = false
var dis_to_label_text : String

func _ready() -> void:
	print("Travel Started----")
	ROUND_COUNT = 0
	dis_to_label_text = dist_to_label.text
	_update_dist_to()
	# _travel()

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	# _inflict_damage()
	CUR_POS = 0
	ROUND_COUNT = 0
	DIST_TO = randi_range(260, 540)
	_travel()

func _inflict_damage():
	torino.TravelDamage.emit()
	torino.UpdateDash.emit()

func _travel():
	while CUR_POS < DIST_TO:
		
		await get_tree().create_timer(TIMER).timeout
		
		ROUND_COUNT += 1
		print("Travel Round " + str(ROUND_COUNT))
		
		CUR_POS += BASE_DIST * SPEED
		_update_dist_to()
		print("Current: " + str(CUR_POS) + " | Dest: " + str(DIST_TO))
		
		if randi_range(0, 100) < 60:
			torino.TravelDamage.emit()
		
		var RE = randi_range(0, R_E_CH) * AREA_MOD * COND_MOD
		print("Random Encounter: " + str(RE) + " | Thresh: " + str(R_E_CH * 0.6))
		
		if (RE) > (R_E_CH * 0.6):
			await _random_event()
			event_occurring = true
		
		print("---------------")

func _random_event():
	event_manager.RandomEvent.emit()

func _update_dist_to():
	dist_to_label.text = dis_to_label_text + " " + str(DIST_TO - CUR_POS)
