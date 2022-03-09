class_name Secret
extends Node

export var _secret_key = 'SECRET'
export var _secret = '' # setup with default value

signal solved

func _ready():
	print('loading secret: ', _secret_key)
	var secret = SecretsKeeper.get(_secret_key)
	print('secret: ', secret)
	if secret != '':
		_secret = secret
		print('secret loaded: ', _secret)

# interface
func solve(answer):
	if !NetworkManager.server and !Globals.is_single_test(): return
	var solved = false
	var _answer = _encode(answer)
	if _validate_state() and _answer == _secret:
		solved = true
		_update_state()
		# set current global state for this
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'was_solved', solved)
	emit_signal('solved', solved)

# should check server global state to validate if this action could be performed
func _validate_state():
	return true

# updates server global state, also unlocks nfts rewards and scores if needed
func _update_state():
	pass

# transform current answer into a plain text format compatible with the secret
func _encode(answer):
	return answer

remote func was_solved(solved):
	# checks if it is pilot
	if NetworkManager.isPilot():
		emit_signal('solved', solved)


# to implement it:
# create an instance of this as a helper resource?
# configure it with the secret_key
# overrides _validate_state by checking requirements to unlock this secret
# overrides _update_state with specific state updates and any blockchain reward trigger
# overrides _encode if needed to transform the answer

# to use it:
# call this resource solve function
# secret.solve(some_answer)
# var result = yield(secret, 'solved')

