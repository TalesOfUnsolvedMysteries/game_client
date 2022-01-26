tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([C.walk_to_clicked()]), 'completed')
	
	if Globals.state.get('Lobby-ELEVATOR_CARD_IN_PC'):
		yield(E.run([
			"Player: Should I remove the elevator program card from the computer."
		]), 'completed')
		
		var answer: DialogOption = yield(
			E.show_inline_dialog(['Yes', 'No']), 'completed'
		)
		if answer.id == 'Opt1':
			E.run([
				I.add_item('ElevatorCard'),
				'Player: I have the elevator program card...',
				'...',
				'Player: Again.'
			])
		else:
			E.run(['Player: No... maybe I want to do some changes to the program.'])
	else:
		E.current_room.use_pc()


func on_look() -> void:
	if not Globals.state['Lobby-PC_POWERED']:
		yield(E.run([
			'Player: Might be useful, but it has no power'
		]), 'completed')
	else:
		yield(E.run([
			'Player: Has some apps that might be useful'
		]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'ElevatorCard':
		E.run([
			"Player: Maybe I can change the behavior of the elevator using this computer.",
			I.remove_item('ElevatorCard')
		])
		Globals.set_state('Lobby-ELEVATOR_CARD_IN_PC', true)
