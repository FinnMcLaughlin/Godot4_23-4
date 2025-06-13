extends Node2D
class_name Building

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var lights: Node2D = $Lights
@onready var label: Label = $Label

@export var building_type : String
@export var has_loot : bool
@export var building_size : int # Enum Small / Medium / Large
@export var light_frames : Array

@export var LOOT_P : float

var loot_progress : float
var being_looted : bool
var finished_looting : bool

var building_data : Dictionary = {}

func _ready() -> void:
	label.hide()
	has_loot = _loot_chance()
	
	building_data = {
		"type": building_type,
		"loot": has_loot,
		"size": _get_size_value(building_size),
		"progress": 0,
		"being_looted": being_looted,
		"finished_looting": finished_looting
	}
	
	if building_data["loot"] == true:
		animated_sprite_2d.play("lootable")
		
		for light in lights.get_children():
			light.set_enabled(true)

func _process(delta: float) -> void:
	if building_data["finished_looting"] == false and area_2d.get_overlapping_bodies().size() > 0:
		if building_data["loot"] == true:
			label.show()
				
			if Input.is_action_pressed("interact"):
				_currently_being_looted(delta)
				
			if building_data["progress"] >= 100:
				print("Finished!!")
				building_data["loot"] = false
				building_data["finished_looting"] = true
				
				for light in lights.get_children():
					light.set_enabled(false)
				_has_loot()
	else:
		label.hide()

	pass

func _loot_chance():
	var loot_v = randi_range(0, 100)
	
	if loot_v <= LOOT_P:
		return true
	else:
		return false

func _has_loot():
	if not building_data["loot"]:
		animated_sprite_2d.play("default")

# Returns speed in which the player can loot
# Reimplement with ENUM and renamed variables
func _get_size_value(size : int):
	match size:
		1:
			return 30
		2:
			return 20
		3:
			return 15

# Implement State Machine
func _currently_being_looted(delta):
	print("Looting")
	
	label.text = "..."
	
	building_data["progress"] += building_data["size"] * delta
	
	print("Progress: " + str(building_data["progress"]))
