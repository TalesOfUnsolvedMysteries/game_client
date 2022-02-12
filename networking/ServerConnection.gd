extends Node
const SERVER = 'http://localhost:3000/'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# SERVER requests
func get_server_status ():
	var result = _get_request('server/status')
	print('current game state', result.gameState)
	print('current player', result.currentPlayer)
	print('current secret', result.secretConnectionKey)

func register_server ():
	var result = _post_request('server/status', {"secret": "secret"})
	if result.connected:
		print('connected successfully as server')
	else:
		print(result.error)

func save_card (filename):
	var result = _post_request('server/status', {"filename": filename})
	print('expected to be saved')

func notify_player_connected (secret, godot_peer_id):
	var params = {
		"success": true,
		"secret": secret,
		"godotPeerID": godot_peer_id,
	}
	var result = _post_request('server/player/connected', params)
	print('expected to be notified')

func notify_player_disconnected (godot_peer_id):
	var result = _post_request('server/player/disconnected', {"godotPeerID": godot_peer_id})
	print('expected to be notified')

func notify_game_over (godot_peer_id, cause_of_death):
	var result = _post_request('server/player/game-over', {"godotPeerID": godot_peer_id, "causeOfDeath": cause_of_death})
	print('expected to be notified')

func reward_points (godot_peer_id, points):
	var result = _post_request('server/player/score', {"godotPeerID": godot_peer_id, "score": points})
	print('expected to be notified')

func reward_game_token (godot_peer_id, reward_id):
	var result = _post_request('server/player/reward', {"godotPeerID": godot_peer_id, "rewardID": reward_id})
	print('expected to be notified')

func notify_pilot_ready ():
	var result = _post_request('server/player/ready', {})
	print('expected to be notified')


# PLAYER requests
func get_user ():
	var result = _get_request('user')
	print(result)
	return result

func request_user_session (secret):
	var result = _post_request('user/request', {"secret": secret})
	print('user id allocated %s' % result.userID)
	return result.userID

func recover_user_session (user_id, secret):
	var result = _post_request('user/recover', {"userID": user_id, "secret": secret})
	print('user recovered? ', result.recovered)
	return result.recovered

func request_turn ():
	var result = _post_request('user/request-turn', {})
	print('turn for this user', result.turn)
	return result.turn

func set_bug_adn (adn):
	var result = _post_request('user/bug/adn', {"adn": adn})
	print('expected to set bug\'s adn')

func set_bug_name (name):
	var result = _post_request('user/bug/name', {"name": name})
	print('expected to set bug\'s name')

func set_bug_intro (intro):
	var result = _post_request('user/bug/intro', {"intro": intro})
	print('expected to set bug\'s intro')

func set_bug_last (last):
	var result = _post_request('user/bug/last', {"last": last})
	print('expected to set bug\'s last')


func can_connect ():
	var result = _get_request('user/can-connect')
	if result.canConnect:
		print(result.secretKey)
		# if can connect should try to connect to the server if not connected already




func _process_response (response):
	var result = response[0]
	var response_code = response[1]
	var headers = response[2]
	var body = response[3]
	var json = JSON.parse(body.get_string_from_utf8())
	return json.get_result()


func _get_request(path):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var url = '%s%s' % [SERVER, path]
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	var response = yield(http_request, 'request_completed')
	remove_child(http_request)
	return _process_response(response)


func _post_request(path, params):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var url = '%s%s' % [SERVER, path]
	error = http_request.request(url, [], true, HTTPClient.METHOD_POST, params)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	var response = yield(http_request, 'request_completed')
	remove_child(http_request)
	return _process_response(response)


