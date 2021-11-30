tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		"Player: I don't want to tear off any photos",
		'Player: What would I want them for?'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: A man is seen next to a monument',
		'Player: The same as in the other color photos',
		'Player: The black and white photos look old',
		'Player: Like immigrants arriving in the city',
		'Player: Maybe they are his grandparents',
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
