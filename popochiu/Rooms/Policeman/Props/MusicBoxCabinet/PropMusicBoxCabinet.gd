tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	
	if Globals.state.get('Jukebox-Secret_Box_OPENED'):
		$Sprite.frame = 1
		yield(E.run([
			'Player: What is this?',
			I.add_item('Usb'),
			"Player: Might be the update for the elevator app mentioned in the technician's notes"
		]), 'completed')


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
