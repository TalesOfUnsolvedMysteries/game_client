tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: There is nothing particular',
		'Player: But the fabric softener smells great',
	]), 'completed')


func on_look() -> void:
	yield(E.run(['Player: It is a very well laid bed']), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
