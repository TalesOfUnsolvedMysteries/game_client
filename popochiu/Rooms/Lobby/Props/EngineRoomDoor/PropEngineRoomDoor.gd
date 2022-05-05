tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		A.play({cue_name = 'sfx_engine_room_locked'}),
		'Player: The door to the engine room is closed',
		'Player: And it looks immovable'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		'Player: Is the door to the engine room'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'KeyEngineRoom':
		E.current_room.open_engine_room()
