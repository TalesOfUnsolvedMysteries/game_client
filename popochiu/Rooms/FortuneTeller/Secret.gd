extends Secret

var configurations = {}

func _ready():
	._ready()
	var json = JSON.parse(_secret)
	configurations = json.result

func solve(_answer):
	if !NetworkManager.server and !Globals.is_single_test(): return
	var solved = false

	var answer = Globals.state.get('RITUAL_configuration')
	var already_solved = Globals.state.get('RITUAL_summoned')
	if configurations.has(answer):
		var target_room: String = configurations[answer]
		solved = target_room
		if not already_solved.has(target_room):
			already_solved.push_back(target_room)
			Globals.set_state('RITUAL_summoned', already_solved)
			self._earn_nft('SUMMON_%s_SPIRIT' % target_room.to_upper())
			yield(get_tree(), 'idle_frame')
		else:
			solved = 'A%s' % solved
		# set current global state for this
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'was_solved', solved)
	emit_signal('solved', solved)
	return solved


# transform current answer into a plain text format compatible with the secret
func _encode(answer):
	return answer

