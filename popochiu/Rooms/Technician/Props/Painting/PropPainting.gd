tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"'Player: I don't understand this kind of art."
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A painting with a lot of symbols.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
