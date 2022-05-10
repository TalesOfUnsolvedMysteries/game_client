tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: Can't open it."
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: Can see other building from here.',
		'Player: Looks like someone is watching TV.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
