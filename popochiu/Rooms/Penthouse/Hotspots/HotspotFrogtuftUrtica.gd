tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: It is fine where it is.',
		'Player: Pity there is no water to irrigate it.'
	])


func on_look() -> void:
	E.run([
		C.face_clicked(),
		'Player: It is a ' + description,
		'Player: Lovely'
	])


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
