tool
extends Prop

export var normal: Texture
export var hidden: Texture
export var painting_key: String = 'LINK_PUZZLE_KEY_POLICEMAN'

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: What a weird painting.',
		'Player: It only has a lot of symbols.'
	]), 'completed')
	
	room.painting.display_paint(normal, hidden, painting_key)


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		"Player: It has symbols I don't understand",
		'Player: And a notch to put something.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		yield(C.walk_to_clicked(false), 'completed')
		room.painting.display_paint(normal, hidden, painting_key)
		I.set_active_item(null, false)
	else:
		.on_item_used(item)
