tool
extends Hotspot

onready var secret: Secret = find_node('Secret')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if Globals.state.get('FirstFloor-102_UNLOCKED'):
		yield(E.run([
			C.walk_to_clicked(),
			A.play({
				cue_name = 'sfx_door_open',
				is_in_queue = true
			})
		]), 'completed')
		E.goto_room('Technician')
	else:
		E.run([
			C.walk_to_clicked(),
			A.play({
				cue_name = 'sfx_door_latch',
				pitch = 2,
				is_in_queue = true
			}),
			'Player: Is closed'
		])


func on_look() -> void:
	if Globals.state.get('FirstFloor-102_UNLOCKED'):
		E.run([
			'Player: Is the opened door to the 102',
		])
	else:
		E.run([
			'Player: Is the door to the 102',
			'Player: Who lives there?',
		])


func on_item_used(item: InventoryItem) -> void:
	secret.on_inventory_item_used(item)
