extends Node2D
class_name Building

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D
@onready var lights: Node2D = $Lights
@onready var label: Label = $Label

const BATTERY = preload("res://scenes/items/battery.tres")

@export var building_type : String
@export var has_loot : bool
@export var building_size : int # Enum Small / Medium / Large
@export var light_frames : Array

@export var LOOT_P : float
@export var MAX_LOOT : int = 1

var current_animation : String

var loot_progress : float
var being_looted : bool
var finished_looting : bool

@export var potential_loot : Array[Item]
@export var building_loot : Array[Item]

var building_data : Dictionary = {}

signal Looting
signal LootingStop

func _ready() -> void:
	current_animation = animated_sprite_2d.animation
	
	label.hide()
	has_loot = _loot_chance()
	
	if has_loot == false:
		finished_looting = true
	else:
		finished_looting = false
	
	building_data = {
		"type": building_type,
		"loot": has_loot, # Bool replaced with loot object array
		"size": _get_size_value(building_size),
		"progress": 0,
		"being_looted": being_looted,
		"finished_looting": finished_looting
	}
	
	if building_data["loot"] == true:
		Looting.connect(_currently_being_looted)
		LootingStop.connect(_reset_text)
		_light_management()
		
		_generate_loot()

func _process(delta: float) -> void:
	if building_data["finished_looting"] == false:
		if building_data["progress"] >= 100:
			
			print("Finished!!")
			
			building_data["finished_looting"] = true
			
			area_2d.get_overlapping_bodies()[0].GiveLoot.emit(building_loot.pick_random())
			
			_light_management()

func _loot_chance():
	var loot_v = randi_range(0, 100)
	
	if loot_v <= LOOT_P:
		return true
	else:
		return false

func _light_management():
	if building_data["finished_looting"] == true:
		animated_sprite_2d.play(current_animation)
		
		for light in lights.get_children():
				light.set_enabled(false)
	else:
		animated_sprite_2d.play(current_animation)
		# animated_sprite_2d.play("lootable")
		
		for light in lights.get_children():
				light.set_enabled(true)

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
	# print("Looting")
	
	label.text = "..."
	
	building_data["progress"] += building_data["size"] * delta
	
	# print("Progress: " + str(building_data["progress"]))

func _reset_text():
	label.text = "E"

func _generate_loot():
	if randi_range(0, 10) > 0:
		building_loot.append(BATTERY)
	#for loot in range(MAX_LOOT):
		#if randi_range(0, 10) > 5:
			#building_loot.append(BATTERY)
		#else:
			#building_loot.append(null)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and building_data["finished_looting"] == false:
		label.show()
		_reset_text()
		body.updateSearchObject.emit(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		label.hide()
		body.removeSearchObject.emit()
