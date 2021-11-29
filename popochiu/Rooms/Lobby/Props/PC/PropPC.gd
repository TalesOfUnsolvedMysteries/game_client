tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([C.walk_to_clicked()]), 'completed')
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
	pass
