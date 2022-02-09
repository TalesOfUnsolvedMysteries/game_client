tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: There is a love letter in the typewriter'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: A typewriter',
		'Player: Like the one used in the Resident Evil series',
		A.play_music('mx_re2_saveroom'),
		'....',
		C.player.face_left(),
		'..',
		C.player.face_right(),
		'Player: What was that?'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
