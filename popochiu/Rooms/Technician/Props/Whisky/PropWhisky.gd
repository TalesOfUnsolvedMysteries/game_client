tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: Do not want to drink that.',
		'Player: Thanks but no thanks.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: Looks like someone kind of strong drink.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
