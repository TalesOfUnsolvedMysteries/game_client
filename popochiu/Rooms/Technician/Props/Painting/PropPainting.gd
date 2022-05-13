tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I don't understand this kind of art."
	]), 'completed')
	
	# TODO: Abrir el popup de la pintura


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A painting with a lot of symbols.',
		'Player: And a notch to put something.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		# TODO: Mostrar el popup de la pintura pero con la cosa oculta
		return
	
	.on_item_used(item)
