tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		C.face_clicked(),
		"Player: I better don't touch that.",
		'Player: Anything here could be haunted.'
	])


func on_look() -> void:
	E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: Looks like the totem of a rooster.'
	])


func on_item_used(item: InventoryItem) -> void:
	pass
