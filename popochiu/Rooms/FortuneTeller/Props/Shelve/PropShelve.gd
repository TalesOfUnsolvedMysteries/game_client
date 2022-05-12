tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if I.is_item_in_inventory('MagicGlasses'):
		$Magicglasses.hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if not I.is_item_in_inventory('MagicGlasses'):
		yield(E.run([
			C.walk_to_clicked(),
			C.face_clicked(),
			"Player: I think I'll take them with me.",
			I.add_item('MagicGlasses')
		]), 'completed')
		
		$Magicglasses.hide()
	else:
		E.run([
			'Player: Nope.',
			'Player: I already have the glasses'
		])


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: The label says "To see what the worldly eye does not see"',
		'..',
		'Player: Sounds nice.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
