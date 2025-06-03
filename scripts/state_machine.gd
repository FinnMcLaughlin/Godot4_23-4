extends Node

@export var initial_state : State

var states : Dictionary = {}
var current_state : State
var prev_state: State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(change_state)
		
		if initial_state:
			initial_state.enter()
			current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	pass
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	pass

func change_state(state, new_state_name, params : Dictionary = {} ):
	if state != current_state:
		return
	
	var new_state : State = states.get(new_state_name.to_lower())

	if !new_state:
		return
	
	if current_state:
		current_state.exit()

	current_state = new_state
	new_state.enter(params)
