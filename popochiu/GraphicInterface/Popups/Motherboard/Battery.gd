extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if not Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		
		Globals.set_state('BATTERY_LAST_LOCATION', 'EngineRoom-MOTHERBOARD_WITH_BATTERY')
		yield(E.run([
			'Player: I need to find a way to charge this battery.',
			I.add_item('MotherboardBattery'),
			# TODO: Reproducir un sonido como de haber sacado algo de un socket
		]), 'completed')
		if I.is_item_in_inventory('MotherboardBattery'):
			hide()
		else:
			E.run([
				'Player: but I don\'t have space on my inventory!',
			])
	else:
		E.run([
			"Player: Now that the battery is fully charged I don't need to remove it from its socket."
		])
