extends Node2D
class_name TravelDemo

@onready var torino: ToyotaTorino = $Torino
@onready var event_manager: EventManager = $EventManager
@onready var event_node: Control = $EventManager/EventNode
@onready var dist_to_label: Label = $DistToLabel
@onready var travel_state_machine: Node = $TravelStateMachine

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

func _on_button_pressed() -> void:
	CUR_POS = 0
	ROUND_COUNT = 0
	DIST_TO = randi_range(260, 540)
	
	travel_state_machine.change_state(null, "Idle")

func _inflict_damage():
	torino.TravelDamage.emit()
	torino.UpdateDash.emit()

func _random_event():
	event_manager.RandomEvent.emit()
	dist_to_label.text = dis_to_label_text + " " + str(DIST_TO - CUR_POS)
