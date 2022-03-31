extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal card_put


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	pass


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'ElevatorCard':
		I.remove_item(item.script_name, false)
		# TODO: Reproducir un sonido de estar poniendo algo en un slot.
		emit_signal('card_put')
		A.play({
			cue_name = 'sfx_elevator_card_insert_board',
			is_in_queue = false
		})
