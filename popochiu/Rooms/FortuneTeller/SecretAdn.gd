extends Secret

var adn_configurations = {}
signal adn_retrieved

func _ready():
	._ready()
	var json = JSON.parse(_secret)
	adn_configurations = json.result

# should check server global state to validate if this action could be performed
func _validate_state():
	return true

# updates server global state, also unlocks nfts rewards and scores if needed
func _update_state():
	pass

# transform current answer into a plain text format compatible with the secret
func _encode(answer):
	return answer

func get_adn_for(room):
	if !NetworkManager.server and !Globals.is_single_test(): return
	var adn = adn_configurations[room]
	emit_signal('adn_retrieved', adn)
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'adn_requested', adn)

remote func adn_requested(adn):
	# checks if it is pilot
	if NetworkManager.isPilot():
		emit_signal('adn_retrieved', adn)


