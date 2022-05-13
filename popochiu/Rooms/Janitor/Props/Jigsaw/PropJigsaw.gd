tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
	]), 'completed')
	E.current_room.show_jigsaw()


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: A jigsaw.',
		"Player: On the back, it says Dracula's inverted castle."
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
