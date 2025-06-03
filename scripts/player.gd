extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED = 150.0

func _ready() -> void:
	global_position = Vector2(-200, -150)

func _physics_process(delta: float) -> void:
	_input_manager()

func _input_manager():
	# Get Input
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if input_direction != Vector2.ZERO:
		animated_sprite.play("idle_2")
		_move(input_direction)
	else:
		animated_sprite.play("idle_3")

func _move(input_direction) -> void:	
	# Update Velocity
	velocity = input_direction * SPEED
	
	if input_direction.x < 0:
		animated_sprite.flip_h = true
		
	elif input_direction.x > 0:
		animated_sprite.flip_h = false
	
	 # Move & Slide function; Velocity applied to player body on map
	move_and_slide()
