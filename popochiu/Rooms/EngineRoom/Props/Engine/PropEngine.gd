tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	Globals.set_state('Lobby-PC_UNLOCKED', true)
	prints('Se desbloquió el computador')
	
	yield(E.run([
		C.walk_to_clicked(),
		'.'
	]), 'completed')
	E.current_room.show_motherboard()


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
