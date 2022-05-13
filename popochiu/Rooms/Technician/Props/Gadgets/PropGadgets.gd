tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.player.face_left(),
		'..',
		C.player.face_right(),
		'..',
		C.player.face_left(),
		'..',
		C.player.face_right(),
		'..',
		'Player: This all looks like junk to me.',
		"Player: Although it could also be a spy's place."
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A lot of electronic devices.',
		'Player: What a mess.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
