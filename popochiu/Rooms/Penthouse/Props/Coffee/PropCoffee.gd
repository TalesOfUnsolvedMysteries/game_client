tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		"Player: I don't like coffee.",
		'Player: Let alone this one, which is all covered with [shake]fungus.[/shake]'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A cup of coffee...',
		'Player: An ooooold cup of coffee.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
