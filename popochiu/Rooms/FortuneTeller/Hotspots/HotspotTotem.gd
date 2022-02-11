tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: For what?"
	])


func on_look() -> void:
	E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: Looks like a kind of symbol.',
		'Player: It says: Gubernatorial Symbol of Mêlée Island™'
	])


func on_item_used(item: InventoryItem) -> void:
	pass
