tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: It is not working.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: It looks like some kind of computer.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'Usb'\
	or item.script_name == 'RegistryUsb'\
	or item.script_name == 'ElevatorCard':
		E.run([
			C.walk_to_clicked(),
			C.face_clicked(),
			'Player: It does not have a port for this.',
			'Player: What a shame.'
		])
		return
	.on_item_used(item)
