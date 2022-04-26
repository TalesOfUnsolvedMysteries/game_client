tool
extends Prop

var _final_description := 'Engine room'

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	if Engine.editor_hint:
		return
	
	if Globals.state.get('Janitor-KEY_ENGINE_ROOM_LOOKED'):
		description = _final_description
	if !Globals.state.get('Janitor-KEY_ENGINE_ROOM-in'):
		$Sprite.frame = 0
		description = _final_description
	I.connect('item_discarded', self, '_on_item_discarded')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if $Sprite.frame == 1:
		yield(E.run([
			C.walk_to_clicked(),
			"Player: I have the engine room's key",
			I.add_item('KeyEngineRoom')
		]), 'completed')
		$Sprite.frame = 0
		description = _final_description
	else:
		E.run(['Player: I have nothing to do with it'])


func on_look() -> void:
	if $Sprite.frame == 1:
		yield(E.run([
			C.walk_to_clicked(),
			'Player: Is the key to the engine room'
		]), 'completed')
		Globals.set_state('Janitor-KEY_ENGINE_ROOM_LOOKED', true)
		description = _final_description
	else:
		E.run(["Player: The engine room's key is not there"])

func _on_item_discarded(item: InventoryItem):
	if item.script_name == 'KeyEngineRoom':
		$Sprite.frame = 1


