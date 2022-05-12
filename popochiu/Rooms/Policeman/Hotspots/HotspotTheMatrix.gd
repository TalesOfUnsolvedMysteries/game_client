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
		'Player: The Matrix.',
		"Player: On march 31st the fight for the future begins.",
		'..',
		'Player: What does it mean?'
	])


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
