tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if !Globals.state.get('Tecnician-ELEVATOR_CARD_IN_LOCKER'):
		E.run([
			'Player: There is nothing in the lockers of interest.',
			'Player: I already took the elevator program card.'
		])
	else:
		Globals.set_state('ELEVATOR_CARD_LAST_LOCATION', 'Tecnician-ELEVATOR_CARD_IN_LOCKER')
		yield(E.run([
			C.walk_to_clicked(),
			"Player: Let see what I can find here.",
			'....', # TODO: Reproducir un sonido como de alguien abriendo cajones de
			#				metal y esculcando.
			'Player: Well... the only thing that looks useful here is this card.',
			I.add_item('ElevatorCard'),
			'Player: Its label says: Elevator program.'
		]), 'completed')


func on_look() -> void:
	yield(E.run([
		"Player: Those are the lockers of the building's technician."
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
