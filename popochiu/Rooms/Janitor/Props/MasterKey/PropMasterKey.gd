tool
extends Prop

var _final_description := 'Master Key'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	if Engine.editor_hint:
		return
	
	if Globals.state.get('Janitor-KEY_102_LOOKED'):
		description = _final_description
	if !Globals.state.get('Janitor-MASTER_KEY-in'):
		$Sprite.frame = 0
		description = _final_description
	I.connect('item_discarded', self, '_on_item_discarded')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if $Sprite.frame == 1:
		yield(E.run([
			C.walk_to_clicked(),
			A.play({cue_name= 'sfx_masterkey_pickup'}),
			I.add_item('MasterKey'),
			'Player: I have the master key',
			'Player: with this key I can open any locked door'
		]), 'completed')
		Globals.set_state('Janitor-KEY_102_LOOKED', true)
		$Sprite.frame = 0
		description = _final_description
	else:
		E.run([
			'Player: The Master key is not in its place',
		])


func on_look() -> void:
	if $Sprite.frame == 1:
		yield(E.run([
			C.walk_to_clicked(),
			'Player: It is the master key'
		]), 'completed')
		Globals.set_state('Janitor-KEY_102_LOOKED', true)
		description = _final_description
	else:
		E.run(["Player: The Master key is not there"])

func _on_item_discarded(item: InventoryItem):
	if item.script_name == 'MasterKey':
		$Sprite.frame = 1

func on_item_used(item: InventoryItem) -> void:
	pass
