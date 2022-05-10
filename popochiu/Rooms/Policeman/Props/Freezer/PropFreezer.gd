tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I can't open it.",
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A freezer.',
		'Player: Why would anyone have such a thing?',
		'Player: They are more practical vertically.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
