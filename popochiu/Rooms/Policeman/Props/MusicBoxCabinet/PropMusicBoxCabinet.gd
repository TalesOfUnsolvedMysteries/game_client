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
				A.play({cue_name = 'sfx_jukebox_open_cabinet',is_in_queue = true}),
				'Player: What is this?',
				I.add_item('Usb'),
				"Player: Might be the update for the elevator app mentioned in the technician's notes"
			]), 'completed')
			A.play({cue_name = 'sfx_usb_pick', is_in_queue = false})
		else:
			yield(E.run([
				"Player: Is empty"
			]), 'completed')
	else:
		yield(E.run([
				A.play({cue_name = 'sfx_door_latch',is_in_queue = true}),
				"Player: It's locked, it doesn't have any keyhole...",
				"Player: How can one unlock this?"
			]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: Is a cabinet.',
		"Player: I wonder what's inside."
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MasterKey':
		E.run([
			C.walk_to_clicked(),
			C.face_clicked(),
			"Player: It doesn't have any keyhole."
		])
		return
	.on_item_used(item)
