extends State
class_name PlayerIdle

@onready var player: Player = $"../.."

@export var DEBUG_MODE : bool = false

func enter(params : Dictionary = {}):
	_log("Entering--- : " + "Player Idle State")
	player.updateState.emit(self)
	player.updateAnimation.emit("idle")

func _log(log_item):
	if DEBUG_MODE:
		print(log_item)
