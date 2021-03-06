extends Secret

export var DOOR_TO_UNLOCK = ''
export var NFT_TO_CLAIM = ''

func _ready():
	._ready()
	connect('solved', self, '_on_solved')

# should check server global state to validate if this action could be performed
func _validate_state():
	# user must have the master key on inventory
	return true

# updates server global state, also unlocks nfts rewards and scores if needed
func _update_state():
	Globals.set_state(DOOR_TO_UNLOCK, true)
	# unlock DOOR NFT
	self._earn_nft(NFT_TO_CLAIM)
	#G.emit_signal('nft_won', Globals.NFTs[NFT_TO_CLAIM])

# transform current answer into a plain text format compatible with the secret
func _encode(answer):
	return answer

func on_inventory_item_used(item: InventoryItem) -> void:
	if Globals.state.get(DOOR_TO_UNLOCK):
		E.run([
			'Player: That door is already opened',
			"Player: What's the point of unlocking a door that is already unlocked",
			I.set_active_item()
		])
		return
	
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	
	var correct = false
	if item.script_name == 'MasterKey':
		yield(E.run([
			'Player: Let\'s try this',
			A.play({
				cue_name = 'sfx_master_key_use',
				is_in_queue = true,
				wait_audio_complete = true
			})
		]), 'completed')
		self.solve(Globals.state['MasterKey-CONFIG'])
	else:
		E.run([
			# TODO: Poner sonido de wrong
			'Player: I can\'t use it here',
		])
		return

func _on_solved(correct):
	if !correct:
		self._on_incorrect_combination()
		return
	A.play({ cue_name = 'sfx_master_key_door_unlocked', is_in_queue = false})
	yield(G, 'nft_shown')
	E.run([
		'Player: Great! Now the Door is open',
		I.set_active_item()
	])
	
	# TODO: validates if all the other doors are already opened
	# if true then discard the master key from the inventory

func _on_incorrect_combination():
	E.run([
		E.wait(0.3),
		A.play({
			cue_name = 'sfx_engine_room_locked',
			pitch = 5,
			is_in_queue = true
		}),
		'Player: umm, it\'s the wrong configuration',
	])
