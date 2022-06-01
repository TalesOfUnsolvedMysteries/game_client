tool
extends Prop

export var normal: Texture
export var hidden: Texture


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: What a weird painting.',
		'Player: It only has a lot of symbols.'
	]), 'completed')
	
	room.painting.appear(normal, hidden)


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		"Player: It has symbols I don't understand",
		'Player: And a notch to put something.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		yield(C.walk_to_clicked(false), 'completed')
		room.painting.appear(normal, hidden)
	else:
		.on_item_used(item)
