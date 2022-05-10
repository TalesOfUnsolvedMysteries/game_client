extends Secret

signal valid_code_entered
signal current_code_changed

var codes := {}

var _available_codes := []
var _current_code := ''
var _matches := 0
var _good_codes = 0

func _ready():
	._ready()
	var json = JSON.parse(_secret)
	codes = json.result


func reset_codes():
	randomize()
	_available_codes = codes.keys()
	_available_codes.shuffle()
	_set_current_code(_available_codes.pop_front())

func _set_current_code(__current_code):
	_current_code = __current_code
	emit_signal('current_code_changed', __current_code)
	if NetworkManager.isServerWithPilot():
		rpc_id(NetworkManager.pilot_peer_id, 'on_current_code_changed', __current_code)

remote func on_current_code_changed(__current_code):
	if NetworkManager.isPilot():
		_current_code = __current_code
		emit_signal('current_code_changed', __current_code)

func check_button(value) -> void:
	if !NetworkManager.server and !Globals.is_single_test(): return
	if _current_code.empty(): return
	var _match = codes[_current_code].find(value) > -1
	if _match:
		_matches += 1
	else:
		_matches = 0
		if !Globals.is_single_test():
			rpc_id(NetworkManager.pilot_peer_id, 'valid_code_was_entered', false)
		emit_signal('valid_code_entered', false)
	
	if _matches == codes[_current_code].length():
		_good_codes += 1
		if _good_codes < 3:
			_set_current_code(_available_codes.pop_front())
			if !Globals.is_single_test():
				rpc_id(NetworkManager.pilot_peer_id, 'valid_code_was_entered', true)
			emit_signal('valid_code_entered', true)
		else:
			Globals.set_state('EngineRoom-MOTHERBOARD_RESET', true)
			self._earn_nft('ELEVATOR_FIXED')
			#G.emit_signal('nft_won', Globals.NFTs['ELEVATOR_FIXED'])
		_matches = 0


remote func valid_code_was_entered(valid_code):
	if NetworkManager.isPilot():
		emit_signal('valid_code_entered', valid_code)


