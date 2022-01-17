extends "res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd"

signal battery_put


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	if I.active \
	and (I.active as InventoryItem).script_name == 'MotherboardBattery':
		I.remove_item(I.active.script_name, false)
		
		emit_signal('battery_put')
		# TODO: Reproducir un sonido de estar poniendo algo en un slot.
