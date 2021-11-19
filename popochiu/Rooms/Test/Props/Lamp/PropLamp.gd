tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Uy. Qué linda lámpara.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
