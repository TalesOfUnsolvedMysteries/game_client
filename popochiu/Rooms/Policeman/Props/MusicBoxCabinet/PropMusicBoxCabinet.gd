tool
extends Prop

func _ready():
	if Globals.state.get('Jukebox-Secret_Box_OPENED') and (I.is_item_in_inventory('Usb') or Globals.state.get('Lobby-USB_IN_PC')):
		$Sprite.frame = 1

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	
	if Globals.state.get('Jukebox-Secret_Box_OPENED'):
		if not I.is_item_in_inventory('Usb') and not Globals.state.get('Lobby-USB_IN_PC'):
			$Sprite.frame = 1
			yield(E.run([
				'Player: What is this?',
				I.add_item('Usb'),
				"Player: Might be the update for the elevator app mentioned in the technician's notes"
			]), 'completed')
		else:
			yield(E.run([
				"Player: Is empty"
			]), 'completed')

func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
