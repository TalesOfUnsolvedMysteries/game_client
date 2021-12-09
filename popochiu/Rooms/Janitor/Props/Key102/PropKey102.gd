tool
extends Prop

var _final_description := 'Door 102'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	if Globals.state.get('Janitor-KEY_102_LOOKED'):
		description = _final_description
	if Globals.state.get('FirstFloor-102_UNLOCKED')\
	or I.is_item_in_inventory(script_name):
		$Sprite.frame = 0
		description = _final_description


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if $Sprite.frame == 1:
		yield(E.run([
			C.walk_to_clicked(),
			'Player: I have the key to door 102',
			I.add_item('Key102')
		]), 'completed')
		Globals.set_state('Janitor-KEY_102_LOOKED', true)
		$Sprite.frame = 0
		description = _final_description
	else:
		E.run([
			'Player: The key to door 102 is not in its place',
		])


func on_look() -> void:
	if $Sprite.frame == 1:
		yield(E.run([
			C.walk_to_clicked(),
			'Player: It is the key to door 102'
		]), 'completed')
		Globals.set_state('Janitor-KEY_102_LOOKED', true)
		description = _final_description
	else:
		E.run(["Player: The 102 key is not there"])


func on_item_used(item: InventoryItem) -> void:
	pass
