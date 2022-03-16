extends Secret

export var DOOR_TO_UNLOCK = ''
export var NFT_TO_CLAIM = ''

func _ready():
	._ready()

# should check server global state to validate if this action could be performed
func _validate_state():
	# user must have the master key on inventory
	return true

# updates server global state, also unlocks nfts rewards and scores if needed
func _update_state():
	Globals.set_state(DOOR_TO_UNLOCK, true)
	# unlock DOOR NFT
	G.emit_signal('nft_won', Globals.NFTs[NFT_TO_CLAIM])

# transform current answer into a plain text format compatible with the secret
func _encode(answer):
	return answer

func on_inventory_item_used(item: InventoryItem) -> void:
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	if item.script_name == 'MasterKey':
		print('trying this combination: ', Globals.state['MasterKey-CONFIG'])
		self.solve(Globals.state['MasterKey-CONFIG'])
	else:
		E.run([
		# TODO: Poner sonido de wrong
			'Player: I can\'t use it here',
		])
		return

	var correct = yield(self, 'solved')
	if !correct:
		E.run([
		# TODO: Poner sonido de puerta trabada
			'Player: umm, it\'s the wrong configuration',
		])
		return

	yield(G, 'nft_shown')
	E.run([
		# TODO: Poner sonido de desbloqueo de puerta
		'Player: Great! Now the Door is open',
	])
	
	# validates if all the other doors are already opened
	# if true then discard the master key from the inventory
	
