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
		'Player: He was Tony Montana.',
		'Player: The world will remember him by another name...',
		'Player: Scarface.',
		'Player: Say hello to my little friend...',
		'..',
		'Player: Hi Tony.'
	])


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
