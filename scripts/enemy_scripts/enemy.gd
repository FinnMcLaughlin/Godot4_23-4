extends CharacterBody2D
class_name Enemy

@export var SPEED : float = 120

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	pass
