tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I don't want to have it."
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: Looks like a trophy.',
		'Player: From what I can see...',
		'Player: It looks like something they would give to a policeman.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
