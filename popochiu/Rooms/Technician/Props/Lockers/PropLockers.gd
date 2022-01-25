tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if I.is_item_in_inventory('ElevatorCard') \
	or Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD'):
		E.run([
			'Player: There is nothing in the lockers of interest.',
			'Player: I already took the elevator programm card.'
		])
	else:
		yield(E.run([
			C.walk_to_clicked(),
			"Player: Let see what I can find here.",
			'....', # TODO: Reproducir un sonido como de alguien abriendo cajones de
			#				metal y esculcando.
			'Player: Well... the only thing that looks useful here is this card.',
			I.add_item('ElevatorCard'),
			'Player: Its label says: Elevator programm.'
		]), 'completed')
		
		Globals.set_state('Technician-CARD_TAKEN', true)


func on_look() -> void:
	yield(E.run([
		"Player: Those are the lockers of the building's technician."
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
