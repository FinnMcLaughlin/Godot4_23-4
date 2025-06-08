extends State
class_name EnemyChasing

@onready var enemy: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var DEBUG_MODE : bool = false

var UPDATE_PP : bool

var player : CharacterBody2D
var player_pos : Vector2

func _ready() -> void:
	player = null
	pass

func enter(params : Dictionary = {}):
	_log("Entering--- : " + "Chasing State")
	
	UPDATE_PP = true
	
	_log(params)
	
	player = params["Player"]
	
	_log(player)
	_log(player.position)
	_log(player.global_position)
	
	pass

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	
	if UPDATE_PP:
		_update_player_position()
		
	enemy.velocity = enemy.global_position.direction_to(Vector2(player_pos.x, player_pos.y)) * enemy.SPEED
	
	# _log(enemy.velocity)
	
	if enemy.velocity.x < 0:
		animated_sprite_2d.flip_h = true
		
	elif enemy.velocity.x > 0:
		animated_sprite_2d.flip_h = false
		
	enemy.move_and_slide()
	
	pass

func _update_player_position():
	UPDATE_PP = false
	
	_log("Updating Player Position")
	
	player_pos = player.global_position
	
	# # _log(player_pos)
	
	await get_tree().create_timer(0.25).timeout
	
	UPDATE_PP = true

func _log(log_item):
	if DEBUG_MODE:
		print(log_item)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(0.5).timeout
		Transitioned.emit(self, "IdleState")
	pass # # Replace with function body.
