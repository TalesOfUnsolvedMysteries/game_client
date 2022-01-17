extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	if not Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		Globals.set_state('EngineRoom-MOTHERBOARD_WITHOUT_BATTERY', true)
		E.run([
			'Player: I need to find a way to charge this battery.',
			I.add_item('MotherboardBattery'),
			# TODO: Reproducir un sonido como de haber sacado algo de un socket
		])
		
		hide()
	else:
		E.run([
			"Player: Now that the battery is fully charged I don't need to remove it from its socket."
		])
