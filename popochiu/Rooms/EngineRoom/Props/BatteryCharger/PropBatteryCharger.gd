tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		"Player: I don´t know what to do with this... or how to use it"
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		'Player: What is that?'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
