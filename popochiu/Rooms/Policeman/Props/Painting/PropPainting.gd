tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: What a weird painting.',
		'Player: It only has a lot of symbols.'
	]), 'completed')
	
	# TODO: Open this painting encoded message


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		"Player: It has symbols I don't understand",
		'Player: And a notch to put something.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
