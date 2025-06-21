extends CharacterBody2D
class_name Player

@onready var state_machine: Node = $StateMachine
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var game: Node2D = $".."

@onready var inventory : Inventory = preload("res://scenes/items/player_inventory.tres")
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var loot_label: Label = $LootLabel

@export var DEBUG_MODE : bool = false
var STATE_CHANGE_BUFFER : bool = false

var input_direction : Vector2
var current_state : State
var search_object

@export var SPEED = 150.0

signal updateState
signal updateAnimation

signal updateSearchObject
signal removeSearchObject
signal GiveLoot
signal LootFinished

func _log(log_item):
	if DEBUG_MODE:
		print(log_item)

func _update_state(new_state):
	current_state = new_state

func _ready() -> void:
	_clear_inventory()
	loot_label.hide()
	
	current_state = state_machine.current_state
	updateState.connect(_update_state)
	
	animated_sprite_2d.play("idle")
	updateAnimation.connect(_update_animation)
	
	search_object = null
	updateSearchObject.connect(_update_search)
	removeSearchObject.connect(_remove_search)
	
	GiveLoot.connect(_give_loot)
	LootFinished.connect(_finish_looting)

func _physics_process(delta: float) -> void:
	_input_manager()

func _input_manager():
	# Get Input
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if current_state is not PlayerLooting:
		if input_direction != Vector2.ZERO:
			if current_state is not PlayerMoving:
				current_state.Transitioned.emit(current_state, "MovingState")
		else:
			if current_state is PlayerIdle:
				current_state.Transitioned.emit(current_state, "IdleState")
			
		if Input.is_action_just_pressed("light_source"):
			print("Flare Dropped")
			game.DropLight.emit(global_position)
		
		if search_object and Input.is_action_pressed("interact"):
			current_state.Transitioned.emit(current_state, "LootingState")
	else:
		if Input.is_action_just_released("interact"):
			current_state.Transitioned.emit(current_state, "IdleState")
			
	if Input.is_action_just_pressed("inventory"):
		if inventory_ui.inventory_open:
			inventory_ui.CloseInv.emit()
		else:
			inventory_ui.OpenInv.emit(inventory)

func _update_search(search_obj):
	search_object = search_obj
	pass

func _update_animation(animation):
	animated_sprite_2d.play(animation)

func _remove_search():
	search_object = null
	pass

func _add_to_inventory(item : Item):
	inventory.items.append(item)

func _remove_from_inventory(item_index : int):
	inventory.items.remove_at(item_index)

func _clear_inventory():
	inventory.items.clear()

func _give_loot(_item):
	print("Loot: " + str(_item))
	
	_finish_looting()
	
	if _item:
		_add_to_inventory(_item)
		loot_label.text = loot_label.text + str(_item.name)
		loot_label.show()
		
		await get_tree().create_timer(0.65).timeout
		
		loot_label.text = "+1 "
		loot_label.hide()

func _finish_looting():
	current_state.Transitioned.emit(current_state, "IdleState")
	search_object = null
