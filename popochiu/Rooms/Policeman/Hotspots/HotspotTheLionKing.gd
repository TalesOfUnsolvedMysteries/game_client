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
		'Player: The greatest adventure of all.',
		'Player: Is finding our place.',
		'Player: In the circle of life.',
		'Player: Walt Disney Pictures presents.',
		'Player: The Lion King.',
		'..',
		'Player: What is a lion?'
	])


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
