extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal removed


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	Globals.set_state('EngineRoom-MOTHERBOARD_WITH_CARD', false)
	Globals.set_state('EngineRoom-ELEVATOR_WORKING', false)
	
	yield(E.run([
		"Player: I'll take the elevator program card.",
		I.add_item('ElevatorCard')
	]), 'completed')
	
	hide()
	emit_signal('removed')


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass