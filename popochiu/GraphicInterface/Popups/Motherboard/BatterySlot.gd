extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal battery_put


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MotherboardBattery':
		I.remove_item(item.script_name, false)
		# TODO: Reproducir un sonido de estar poniendo algo en un slot.
		emit_signal('battery_put')
