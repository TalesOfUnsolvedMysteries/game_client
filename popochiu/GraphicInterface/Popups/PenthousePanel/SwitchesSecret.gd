extends Secret
sync var _switches = [0, 0, 0, 0, 0, 0, 0] setget set_switches
signal switches_changed
signal switch_pressed
signal target_updated

var pressed = 0
export sync var target = 0

var _switch_types = [
	15,  23,  27,  30,  39,  51,  54,  57,
	58,  60,  75,  89,  90, 120, 147, 150,
	153, 154, 178, 180, 184, 201, 210, 216,
	240, 294, 306, 308, 312, 402, 408, 420,
	432, 456, 464, 480
]

func _ready():
	._ready()
	if !NetworkManager.server and !Globals.is_single_test(): return
	pressed = 0
	var index = 0
	_switch_types.shuffle()
	for _switch in parse_json(_secret):
		_switches[index] = _switch_types[index]
		index += 1
	print(_switches)
		
	target = 0
	var values = range(0, len(_switches))
	values.shuffle()
	for i in range(0, 4 + randi()%2):
		target ^= _switches[values[i]]
		print(values[i])
	if NetworkManager.isServerWithPilot():
		rpc_id(NetworkManager.pilot_peer_id, '_on_target_updated', target)
		rpc_id(NetworkManager.pilot_peer_id, '_on_switches_updated', _switches)

#overwrites solve
func solve(_a):
	if !NetworkManager.server and !Globals.is_single_test(): return

	var solved = false
	solved = pressed == target

	if solved:
		Globals.set_state('Penthouse-COMPARTIMENT_OPENED', true)
		self._earn_nft('DETECTIVE')
		#G.emit_signal('nft_won', Globals.NFTs['DETECTIVE'])
		

	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'was_solved', solved)
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
	
remote func _on_target_updated(_target):
	if NetworkManager.isPilot():
		target = _target
		emit_signal('target_updated', _target)

remote func _on_switches_updated(_sw):
	if NetworkManager.isPilot():
		set_switches(_sw)

remote func switch_pressed(pressed):
	# checks if it is pilot
	if NetworkManager.isPilot():
		emit_signal('switch_pressed', pressed)
