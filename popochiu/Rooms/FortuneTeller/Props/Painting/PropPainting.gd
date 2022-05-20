tool
extends Prop

export var normal: Texture
export var hidden: Texture


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I don't understand this kind of art."
	]), 'completed')
	
	room.painting.appear(normal, hidden)


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A painting with a lot of symbols.',
		'Player: And a notch to put something.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		yield(C.walk_to_clicked(false), 'completed')
		room.painting.appear(normal, hidden)
	else:
		.on_item_used(item)
