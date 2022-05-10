tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		"Player: It's fine where it is"
	])


func on_look() -> void:
	E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: The Godfather.',
		"Player: I'm gonna make him an offer he can't refuse.",
		'..',
		'Player: To whom?'
	])


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
