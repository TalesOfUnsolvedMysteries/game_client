extends Secret

signal progress_calculated

func _ready():
	._ready()

# should check server global state to validate if this action could be performed
func _validate_state():
	return true

# updates server global state, also unlocks nfts rewards and scores if needed
func _update_state():
	Globals.set_state('Jukebox-Secret_Box_OPENED', true)
	G.emit_signal('nft_won', Globals.NFTs['MELODY_LOVER'])

# transform current answer into a plain text format compatible with the secret
func _encode(answer):
	return answer

func get_progress(answer: String):
	if !NetworkManager.server and !Globals.is_single_test(): return
	var progress = 0
	if answer[0] == _secret[2]:
		progress = 1
	elif answer[1] == _secret[2] and answer[0] == _secret[1]:
		progress = 2
	if answer == _secret:
		progress = 3
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'progress_calculated', progress)
	emit_signal('progress_calculated', progress)
	
remote func progress_calculated(progress):
	# checks if it is pilot
	if NetworkManager.isPilot():
		emit_signal('progress_calculated', progress)

