extends State
class_name PlayerMoving

@onready var player: Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var DEBUG_MODE : bool = false

func enter(params : Dictionary = {}):
	_log("Entering--- : " + "Player Moving State")
	player.updateState.emit(self)
	player.updateAnimation.emit("player_moving")

func _log(log_item):
	if DEBUG_MODE:
		print(log_item)

func physics_update(delta):
	player.velocity = player.input_direction * player.SPEED
	
	if player.input_direction.x < 0:
		animated_sprite_2d.flip_h = true
		
	elif player.input_direction.x > 0:
		animated_sprite_2d.flip_h = false
	
	player.move_and_slide()
