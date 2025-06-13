extends CharacterBody2D
class_name Enemy

@export var SPEED : float = 120

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var tp : Vector2
var chasing : bool

signal Chase

func _ready() -> void:
	Chase.connect(_chasing)
	chasing = false

func _physics_process(delta: float) -> void:
	if chasing:
		_chase()
	pass

func _chase():
	nav_agent.target_position = tp
	nav_agent.set_velocity(to_local(nav_agent.get_next_path_position()).normalized())
	pass
	
func _chasing():
	if chasing:
		chasing = false
	else:
		chasing = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity * SPEED
	move_and_slide()
	pass
