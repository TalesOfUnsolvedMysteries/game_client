tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([C.walk_to_clicked()]), 'completed')
	room.use_pc()


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
		yield(E.run([
			"Player: Maybe I can change the behavior of the elevator using this computer.",
			I.remove_item('ElevatorCard')
		]), 'completed')
		A.play({
			cue_name = 'sfx_elevator_card_insert_pc',
			is_in_queue = false
		})
		Globals.set_state('Lobby-ELEVATOR_CARD_IN_PC', true)
