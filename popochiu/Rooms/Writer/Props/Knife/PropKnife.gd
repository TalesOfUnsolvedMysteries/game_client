tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I'm not going to touch it.",
		"Player: I don't want to damage the evidence.",
		'Player: And to be blamed for a crime I did not commit.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: OHMYGA! Its a knife full of blood.',
		'.',
		"Player: Bug's blood... of course."
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
