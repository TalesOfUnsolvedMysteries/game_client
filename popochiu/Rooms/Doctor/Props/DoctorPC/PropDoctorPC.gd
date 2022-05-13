tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([]), 'completed')


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	yield(E.run([
		C.player_walk_to(room.get_point('stand_pc'), true),
		C.player.face_left()
	]), 'completed')
	if not item.script_name == 'ADNpicker':
		return
	
	var adn_content: String = Globals.state.get('ADN_picker_content')
	
	if adn_content.empty():
		# not sure if the popup show appear here?
		yield(E.run([
			'Player: there is no sample to process.',
		]), 'completed')
		return

	yield(E.run([
		'Player: the pc will process this sample.',
	]), 'completed')


