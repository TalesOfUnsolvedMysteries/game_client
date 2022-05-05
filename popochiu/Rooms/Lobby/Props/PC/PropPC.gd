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
		var version = Globals.state.get('PC_ELEVATOR_APP_VERSION')
		var elevator_state = Globals.state.get('ELEVATOR_ENABLED')
		if (version == 1 and elevator_state > 0)\
		or (version == 2 and elevator_state == 31):
			yield(E.run([
				C.walk_to_clicked(),
				"Player: The elevator card is already updated.",
			]), 'completed')
			return
		yield(E.run([
			C.walk_to_clicked(),
			"Player: Maybe I can change the behavior of the elevator using this computer.",
			I.remove_item('ElevatorCard')
		]), 'completed')
		A.play({
			cue_name = 'sfx_elevator_card_insert_pc',
			is_in_queue = false
		})
		Globals.set_state('Lobby-ELEVATOR_CARD_IN_PC', true)
	elif item.script_name == 'Usb':
		yield(E.run([
			C.walk_to_clicked(),
			"Player: USB connected to the PC.",
			A.play({cue_name = 'sfx_usb_pc_insert'}),
			I.remove_item('Usb'),
			Globals.set_state('Lobby-USB_IN_PC', true)
		]), 'completed')
		room.use_pc()

