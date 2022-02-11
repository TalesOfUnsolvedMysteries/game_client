tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I don't reach."
	])


func on_look() -> void:
	E.run([
		C.face_clicked(),
		'Player: Beady.'
	])


func on_item_used(item: InventoryItem) -> void:
	pass
