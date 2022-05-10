tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: There seems to be nothing useful inside.',
		'Player: Only crime documents and police records.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A BIG files cabinet.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
