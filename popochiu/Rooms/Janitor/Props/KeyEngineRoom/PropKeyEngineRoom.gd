tool
extends Prop

func _ready():
	if Globals.state.get('Lobby-ENGINE_ROOM_UNLOCKED'):
		hide()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		"Player: I have the engine room's key",
		I.add_item('KeyEngineRoom')
	]), 'completed')
	$Sprite.frame = 0


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
