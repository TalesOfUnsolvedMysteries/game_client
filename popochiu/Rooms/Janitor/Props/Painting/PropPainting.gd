tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: Do not understand this art.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: It has symbols that I don´t understand.',
		'Player: And a notch to put something.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
