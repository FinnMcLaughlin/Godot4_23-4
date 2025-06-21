extends Control
class_name InventoryUI

@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

@export var inventory_open : bool

var slot_count : int
var inventory : Inventory

signal OpenInv
signal CloseInv

func _ready() -> void:
	_close()
	
	slot_count = slots.size()
	
	OpenInv.connect(_open)
	CloseInv.connect(_close)

func _open(inv : Inventory) -> void:
	inventory_open = true
	visible = true
	inventory = inv
	
	_update_slots()

func _close() -> void:
	inventory_open = false
	visible = false

func _update_slots():
	for item_i in range(min(inventory.items.size(), slot_count)):
		slots[item_i]._item_update(inventory.items[item_i])
