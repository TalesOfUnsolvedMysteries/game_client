tool
extends Hotspot

onready var secret: Secret = find_node('Secret')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if Globals.state.get('ThirdFloor-302_UNLOCKED'):
		yield(E.run([
			C.walk_to_clicked(),
			A.play({
				cue_name = 'sfx_door_open',
				is_in_queue = true
			})
		]), 'completed')
		E.goto_room('FortuneTeller')
	else:
		E.run([
			C.walk_to_clicked(),
			"Player: It's locked"
		])


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	secret.on_inventory_item_used(item)
