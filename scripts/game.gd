extends Node2D
class_name Game

@onready var L_SOURCE = preload("res://scenes/l_source.tscn")

signal DropLight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DropLight.connect(_drop_light)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _drop_light(coord : Vector2):
	var light = L_SOURCE.instantiate()
	light.global_position = coord
	add_child(light)
	pass
