extends Node

var secret_key = 'XZA'

var user_file = "user://user.save"
var user_id = 0 setget set_user_id
var turn = 0

var user_obj = {}


onready var password = Utils.generate_word(16)
var cookie = ''
var is_server = false
var server_request = false

var _is_connecting_to_server = false

var http_request_handler = load('res://networking/HttpRequestHandler.gd')
var near_connection = load('res://networking/NearConnection.gd')

signal connection_updated
signal userID_assigned
signal turn_assigned
signal user_loaded
signal join_to_server_requested

enum CONNECTION_STATUS {
	OFFLINE,
	RECOVERING_CREDENTIALS,
	CREDENTIALS_RECOVERED,
	CONNECTING,
	ESTABLISHED,
	HANDSHAKING,
	CONNECTED,
	REJECTED,
	ERROR,
	CLOSED
}
var status = CONNECTION_STATUS.OFFLINE

func _ready():
	randomize()
	yield(_pass_arguments(), 'completed')
	_check_status()
	near_connection.connect('credentials_loaded', self, 'set_near_credentials')
	near_connection.connect('user_loaded', self, 'emit_signal', ['user_loaded'])
	near_connection._near_setup()

func _pass_arguments():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]

	if arguments.has('secret_key'):
		secret_key = arguments.get('secret_key')
		print('secret key: %s' % secret_key)
	
	server_request = arguments.has('server') and arguments.get('server')
	if server_request:
		print('init register server')
		yield(_check_server_connection(), 'completed')
		yield(NetworkManager.init_server(), 'completed')
		yield(register_server(), 'completed')
		print('end register server')
	else:
		http_request_handler.connect('set_cookie', self, 'save_user')
		load_user_data()
		yield(_check_server_connection(), 'completed')
		if status == CONNECTION_STATUS.ERROR: return
		if user_id != 0:
			var recovered = yield(recover_user_session(), 'completed')
			if recovered:
				var user = yield(get_user(), 'completed')
				print(user)
				set_user_id(user.userID)
				turn = user.turn
				emit_signal('turn_assigned', user.turn)
			else:
				set_status(CONNECTION_STATUS.REJECTED)
				print('user recovery fails')
				set_user_id(0)
				#var user = yield(request_user_session(), 'completed')
				#print(user)

func _check_server_connection():
	var result = yield(http_request_handler._get_request(self, ''), 'completed')	# ping
	if result and result.has('message') and result.message == 'bug':
		set_status(CONNECTION_STATUS.CONNECTED)
	else:
		set_status(CONNECTION_STATUS.ERROR)
		return

func save_user ():
	var file = File.new()
	file.open(user_file, File.WRITE)
	print('%d %s' % [user_id, password])
	file.store_string('%d=:=%s=:=%s' % [user_id, password, cookie])
	file.close()


func load_user_data ():
	var file = File.new()
	if file.file_exists(user_file):
		set_status(CONNECTION_STATUS.RECOVERING_CREDENTIALS)
		file.open(user_file, File.READ)
		var data = file.get_as_text().split('=:=')
		user_id = int(data[0])
		password = data[1]
		cookie = data[2]
		print(user_id, password, cookie)
		file.close()
	else:
		password = Utils.generate_word(16)

remote func player_joined(message):
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	print(message)
	if !NetworkManager.server:
		rpc_id(1, "validate_connection", secret_key)

remote func validate_connection(_secret_key):
	var id = get_tree().get_rpc_sender_id()
	if is_server:
		yield(get_server_status(), 'completed')
	if secret_key != _secret_key:
		get_tree().network_peer.disconnect_peer(id)
		notify_player_connection_fails(id)
		#send_message_ws('gs_connectionFail:%s' % secret_key)
	else:
		print ('SERVER: connection successful')
		notify_player_connected(secret_key, id)
		#send_message_ws('gs_connectionSuccess:%s-%d' % [secret_key, id])


func player_connected(player_id):
	rpc_id(player_id, 'player_joined', 'hola')


# SERVER requests
var game_state = 0
func get_server_status ():
	var result = yield(http_request_handler._get_request(self, 'server/status'), 'completed')
	if result.has('secretConnectionKey'):
		secret_key = result.secretConnectionKey
	if result.has('gameState'):
		var updated = game_state != int(result.gameState)
		if updated:
			game_state = result.gameState
			if game_state == 4:		# assignin pilot?
				print('assigning pilot')
				NetworkManager.start_sync_pilot(int(result.currentPlayer))
			if game_state == 5:
				print('printing card')
				var _filename = '%s.png' % turn
				E.goto_room('BugCard')
				yield(get_tree().create_timer(3), 'timeout')
				Utils.take_screenshot(_filename)
				yield(get_tree().create_timer(2), 'timeout')
				yield(save_card(_filename), 'completed')
				E.goto_room('Menu')

	return result

func register_server ():
	print('rs: going to register the server')
	var result = yield(http_request_handler._post_request(self, 'server/register', {"secret": secret_key}), 'completed')
	print('rs: end transaction')
	print(result)
	if result.has('connected') and result.connected:
		print('connected successfully as server')
		is_server = true
	else:
		print(result)
	return result

func save_card (filename):
	var result = yield(http_request_handler._post_request(self, 'server/card', {"filename": filename}), 'completed')
	print('expected card to be saved')
	return result

func notify_player_connected (secret, godot_peer_id):
	var params = {
		"success": true,
		"secret": secret,
		"godotPeerID": godot_peer_id,
	}
	var result = yield(http_request_handler._post_request(self, 'server/player/connected', params), 'completed')
	print('expected to be notified')

func notify_player_connection_fails (godot_peer_id):
	var params = {
		"success": false,
		"godotPeerID": godot_peer_id,
	}
	var result = yield(http_request_handler._post_request(self, 'server/player/connected', params), 'completed')
	print('player connected: expected to be notified')

func notify_player_disconnected (godot_peer_id):
	var result = yield(http_request_handler._post_request(self, 'server/player/disconnected', {"godotPeerID": godot_peer_id}), 'completed')
	print('player disconnected: expected to be notified')

func notify_game_over (godot_peer_id, cause_of_death):
	var result = yield(http_request_handler._post_request(self, 'server/player/game-over', {"godotPeerID": godot_peer_id, "causeOfDeath": cause_of_death}), 'completed')
	print('game over: expected to be notified')

func reward_points (points):
	var result = yield(http_request_handler._post_request(self, 'server/player/score', {"godotPeerID": NetworkManager.pilot_peer_id, "score": points}), 'completed')
	print('reward points: expected to be notified')

func reward_game_token (reward_id):
	var result = yield(http_request_handler._post_request(self, 'server/player/reward', {"godotPeerID": NetworkManager.pilot_peer_id, "rewardID": reward_id}), 'completed')
	print('reward game token: expected to be notified')

func notify_pilot_ready ():
	var result = yield(http_request_handler._post_request(self, 'server/player/ready', {}), 'completed')
	print('pilot ready: expected to be notified')


# PLAYER requests
func set_user(user_obj):
	set_user_id(user_obj.userID)
	set_turn(user_obj.turn)
	emit_signal('user_loaded')

func get_user ():
	user_obj = yield(http_request_handler._get_request(self, 'user'), 'completed')
	set_user(user_obj)
	return user_obj

func request_user_session ():
	yield(get_tree(), "idle_frame")
	if user_id != 0:
		return false
	var result = yield(http_request_handler._post_request(self, 'user/request', {"secret": password}), 'completed')
	print('user id allocated %s' % result.userID)
	set_user_id(result.userID)
	save_user()
	return result

func recover_user_session ():
	yield(get_tree(), "idle_frame")
	set_status(CONNECTION_STATUS.RECOVERING_CREDENTIALS)
	var result = yield(http_request_handler._post_request(self, 'user/recover', {"userID": user_id, "secret": password}), 'completed')
	print('user recovered? ', result.recovered)
	if result.recovered:
		set_status(CONNECTION_STATUS.CREDENTIALS_RECOVERED)
		var user = yield(get_user(), 'completed')
		print(user)
		set_user_id(user.userID)
		turn = user.turn
		emit_signal('turn_assigned', user.turn)
		print(user)
		return user
	else:
		set_status(CONNECTION_STATUS.REJECTED)
		
		print('user recovery fails')
		set_user_id(0)
		var user = yield(request_user_session(), 'completed')
		print(user)
		return user

func request_turn ():
	yield(get_tree(), "idle_frame")
	if user_id == 0: return 0	# request a user first
	if turn != 0: return 0	# user with a turn already
	var result = yield(http_request_handler._post_request(self, 'user/request-turn', {}), 'completed')
	if result.has('turn'):
		print('turn for this user', result.turn)
		turn = result.turn
		emit_signal('turn_assigned', result.turn)
		_is_connecting_to_server = false
		return result.turn
	return 0

func set_bug (adn, name):
	var result = yield(http_request_handler._post_request(self, 'user/bug', {"name": name, "adn": adn}), 'completed')
	print('expected to set bug\'s name and adn')

func set_near_credentials (account_id):
	var result = yield(http_request_handler._post_request(self, 'user/near-credentials', {"accountId": account_id, "secret": password}), 'completed')

	if result.assigned:
		print('yeah it is valid')
	else:
		print('no it is not')

func set_bug_intro (intro):
	var result = yield(http_request_handler._post_request(self, 'user/bug/intro', {"intro": intro}), 'completed')
	print('expected to set bug\'s intro')

func set_bug_last (last):
	var result = yield(http_request_handler._post_request(self, 'user/bug/last', {"last": last}), 'completed')
	print('expected to set bug\'s last')


func sync_state ():
	var result = yield(http_request_handler._get_request(self, 'user/sync-state'), 'completed')
	set_user(result.user)
	if result.canConnect and !_is_connecting_to_server:
		_is_connecting_to_server = true
		secret_key = result.secretKey
		NetworkManager.request_join(Globals.SERVER_IP)
		emit_signal('join_to_server_requested')


func set_status(_new_status):
	status = _new_status
	emit_signal('connection_updated', status)

func set_user_id(_user_id):
	if int(_user_id) == user_id: return
	user_id = int(_user_id)
	emit_signal('userID_assigned', user_id)

func set_turn(_turn):
	if int(_turn) == turn: return
	turn = int(_turn)
	Globals.turn = turn
	emit_signal('turn_assigned', turn)

func _check_status():
	if is_server:
		yield(get_server_status(), 'completed')
		yield(get_tree().create_timer(1), 'timeout')
	else:
		if E.current_room.script_name == 'MainMenu' and !_is_connecting_to_server:
			yield(sync_state(), 'completed')
		yield(get_tree().create_timer(5), 'timeout')
	call_deferred('_check_status')
