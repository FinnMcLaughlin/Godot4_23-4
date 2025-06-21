extends State
class_name PlayerLooting

@onready var player: Player = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

@export var DEBUG_MODE : bool = false

func _log(log_item):
	if DEBUG_MODE:
		print(log_item)

func enter(params : Dictionary = {}):
	_log("Entering--- : " + "Player Looting State")
	player.updateState.emit(self)
	animated_sprite_2d.hide()

func exit():
	animated_sprite_2d.show()
	if player.search_object:
		player.search_object.LootingStop.emit()
		
		if player.search_object.building_data["finished_looting"] == true:
			player.search_object.label.hide()

func physics_update(delta):
	_log(player.search_object)
	player.search_object.Looting.emit(delta)
	pass
