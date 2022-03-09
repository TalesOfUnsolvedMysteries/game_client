tool
extends Prop

onready var secret: Secret = find_node('Secret')

func _ready() -> void:
	if Globals.state.get('EngineRoom-SWITCH_BOX_OPENED'):
		$Sprite.frame = 1
	if Globals.state.get('Lobby-PC_POWERED'):
		$Sprite.frame = 2


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([C.walk_to_clicked()]), 'completed')
	
	if not Globals.state.get('EngineRoom-SWITCH_BOX_OPENED'):
		E.current_room.show_lock()
	elif not Globals.state.get('Lobby-PC_POWERED'):
		D.show_dialog('SwitchPCPower')
	else:
		E.run(['Player: The switch that powers the lobby is on'])


func on_look() -> void:
	if not Globals.state.get('EngineRoom-SWITCH_BOX_OPENED'):
		yield(E.run([
			'Player: Might be a switch box. But it is closed.'
		]), 'completed')
	else:
		E.run(['Player: A switch box'])


func on_item_used(item: InventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func check_combination(comb: String) -> void:
	secret.solve(comb)
	var correct = yield(secret, 'solved')
	if correct:
		$Sprite.frame = 1
		A.play({cue_name = 'sfx_lock_open', is_in_queue = false})
		E.current_room.hide_lock()


func open() -> void:
	$Sprite.frame = 1


func turn_on_switch() -> void:
	$Sprite.frame = 2
