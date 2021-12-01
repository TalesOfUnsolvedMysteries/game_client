tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		C.walk_to_clicked(),
		'Player: It is not working...'
	])


func on_look() -> void:
	E.run([
		'Player: The elevator',
		'Player: Probably gives access to the other floors',
	])


func on_item_used(item: InventoryItem) -> void:
	pass
