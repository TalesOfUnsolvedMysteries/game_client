extends Secret
sync var _switches = [0, 0, 0, 0, 0, 0] setget set_switches
signal switches_changed
signal switch_pressed

var pressed = 0
export var target = 0
export var NFT_REWARD = ''

func _ready():
	._ready()
	if !NetworkManager.server and !Globals.is_single_test(): return
	pressed = 0
	var index = 0
	for _switch in parse_json(_secret):
		_switches[index] = int(_switch)
		index += 1
	
	if NetworkManager.isServerWithPilot():
		rset('_switches', _switches)

#overwrites solve
func solve(_a):
	if !NetworkManager.server and !Globals.is_single_test(): return

	var solved = false
	solved = pressed == target

	if solved:
		Globals.set_state('ELEVATOR_ENABLED', target)
		self._earn_nft(NFT_REWARD)
		#G.emit_signal('nft_won', Globals.NFTs[NFT_REWARD])

	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'was_solved', solved)
	print('pressed: ', pressed)
	emit_signal('solved', solved)
	return solved

func set_switches(_sw):
	_switches = _sw
	emit_signal('switches_changed')

func toggle_switch(value, index):
	if !NetworkManager.server and !Globals.is_single_test(): return
	pressed = pressed ^ _switches[index]
	self._update_switches()

func _update_switches():
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'switch_pressed', pressed)
	emit_signal('switch_pressed', pressed)

remote func switch_pressed(pressed):
	# checks if it is pilot
	if NetworkManager.isPilot():
		emit_signal('switch_pressed', pressed)
