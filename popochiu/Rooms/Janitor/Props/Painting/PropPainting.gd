tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Not pickin that up'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		'Player: It has symbols that I don´t understand',
		'Player: And a notch to put something'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
