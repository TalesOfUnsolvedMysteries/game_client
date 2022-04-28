extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal removed


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	Globals.set_state('EngineRoom-ELEVATOR_WORKING', false)
	Globals.set_state('ELEVATOR_CARD_LAST_LOCATION', 'EngineRoom-MOTHERBOARD_WITH_CARD')
	
	yield(E.run([
		"Player: I'll take the elevator program card.",
		I.add_item('ElevatorCard'),
	]), 'completed')
	
	if I.is_item_in_inventory('ElevatorCard'):
		A.play({
			cue_name = 'sfx_elevator_card_pick',
			is_in_queue = false
		})
		hide()
		emit_signal('removed')
	else:
		E.run([
			'Player: I don\'t have space on my inventory!',
		])


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass
