tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: I can see other buildings from here.',
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A great view has this room.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
