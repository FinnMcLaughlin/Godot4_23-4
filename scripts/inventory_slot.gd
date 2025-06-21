extends Panel
class_name InventorySlot

@onready var inventory_slot_item_sprite : Sprite2D = $CenterContainer/Panel/ItemDisplay2D

func _item_update(item : Item):
	if !item:
		inventory_slot_item_sprite.visible = false
	else:
		inventory_slot_item_sprite.texture = item.texture
		inventory_slot_item_sprite.visible = true
