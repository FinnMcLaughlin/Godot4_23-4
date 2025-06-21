extends Node
class_name EventManager

@onready var event_node: Control = $EventNode
@onready var label: Label = $EventNode/ColorRect/Label

var events_raw : Dictionary
var events_rarity : Dictionary
var occurred_events : Dictionary

enum rarity {
	COMMON = 9,
	LESS_COMMON = 7,
	OCCASIONAL = 3,
	RARE = 1
}

signal RandomEvent
signal HideEvent

func _ready() -> void:
	events_raw = _load_encounters()
	
	_sort_by_rarity()
	RandomEvent.connect(_get_random_event)
	
	for r in rarity:
		occurred_events[r] = []
	
	HideEvent.connect(_hide_event)
	#RandomEvent.emit()

func _load_encounters():
	var file = FileAccess.open("res://data/encounter_data.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		return JSON.parse_string(content)
	return []

func _sort_by_rarity():
	for event in events_raw.events:
		if not events_rarity.has(event.rarity):
			events_rarity[event.rarity] = []
		
		events_rarity[event.rarity].append(event)

func _roll_for_rarity():
	var r_total = 0
	var roll = randi_range(0, 100)
	
	print("Rolled --- " + str(roll))
	for en_r in rarity:
		r_total += rarity.get(en_r) * 5
		if roll <= r_total:
			return en_r

func _get_random_event():
	var rand_rarity : String = _roll_for_rarity()
	var chosen_event = events_rarity.get(rand_rarity.to_lower()).pick_random()
	
	if events_rarity.get(rand_rarity.to_lower()).size() == occurred_events[rand_rarity].size():
		print("Clearing Events -- " + str(rand_rarity))
		occurred_events[rand_rarity].clear()
	
	while chosen_event in occurred_events[rand_rarity]:
		print("Reselecting Event")
		chosen_event = events_rarity.get(rand_rarity.to_lower()).pick_random()
	
	occurred_events[rand_rarity].append(chosen_event)
	print("Chosen Event: " + str(chosen_event))
	
	_display_event(chosen_event)

func _display_event(event):
	var e_text = event.text
	
	if event.type == "damage":
		e_text += "\n" + str(event.result)
		
	_update_text(e_text)
	event_node.show()

func _update_text(text):
	label.text = text

func _hide_event():
	event_node.hide()
