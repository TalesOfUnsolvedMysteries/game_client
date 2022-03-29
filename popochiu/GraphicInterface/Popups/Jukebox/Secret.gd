extends Secret

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

