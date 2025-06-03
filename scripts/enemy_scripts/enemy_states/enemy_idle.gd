extends State
class_name EnemyIdle

@export var DEBUG_MODE : bool = false

func _ready() -> void:
	pass

func enter(params : Dictionary = {}):
	_log("Entering--- : " + "Idle State")
	pass

func exit():
	pass

func update(delta):
	pass

func _log(log_item):
	if DEBUG_MODE:
		print(log_item)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Transitioned.emit(self, "ChasingState", {"Player" : body})
	pass # Replace with function body.
