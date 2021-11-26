extends Node

const SERVER_PORT = 7333
const MAX_PLAYERS = 255

var server = false
var client = false

sync var pilot_peer_id = -1
var pilotOn = false

var _connected = false
signal server_started
signal control_taken
signal control_lost

func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnected')


func init_server():
	print('initializating server')
	var net = NetworkedMultiplayerENet.new()
	net.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = net
	print('server started with peer: ', get_tree().get_network_unique_id())
	server = true
	WebsocketManager.register_game_server()
	emit_signal('server_started')


func set_pilot(peer_id):
	if !server: return
	print('give control')
	pilot_peer_id = peer_id
	rset_id(peer_id, 'pilot_peer_id', pilot_peer_id)
	rpc_id(peer_id, 'take_control')
	# demo - test
	yield(get_tree().create_timer(5), 'timeout')
	game_over('time is up')


func game_over(death_cause):
	print('remove control')
	var peer_id = pilot_peer_id
	pilot_peer_id = -1
	pilotOn = false
	rset_id(peer_id, 'pilot_peer_id', pilot_peer_id)
	rpc_id(peer_id, 'remove_control')
	print('game over')
	print('gs_gameOver:%d-%s' % [peer_id, death_cause])
	WebsocketManager.send_message_ws('gs_gameOver:%d-%s' % [peer_id, death_cause])


remote func take_control():
	if !client: return
	if pilot_peer_id != get_tree().get_network_unique_id():
		print('exception, user unauthorized')
		pilot_peer_id = -1
		return
	print('this player has the control!')
	emit_signal('control_taken')
	rpc_id(1, 'pilot_engage')


remote func pilot_engage():
	if !server: return
	var peer_id = get_tree().get_rpc_sender_id()
	if peer_id != pilot_peer_id:
		print('not authorized')
		return
	pilotOn = true


remote func remove_control():
	if !client: return
	print('control lost')
	emit_signal('control_lost')


func request_join(server_ip):
	client = true
	print('connecting to the server...')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, SERVER_PORT)
	get_tree().network_peer = peer


# server and client
func _player_connected(player_id):
	print('should register players connected to the game ', player_id)
	if server:
		WebsocketManager.player_connected(player_id)
		#rpc_id(player_id, 'player_joined', 'hola')


# server and client
func _player_disconnected(player_id):
	print('should register what players get disconected ', player_id)


# client
func _connected_ok():
	_connected = true
	print('connection successful')


# client
func _connected_fail():
	_connected = false
	print('connection fail')


# client - most probably server kicked this player
func _server_disconnected():
	_connected = false
	print('server is down')
	print(get_tree().has_network_peer())
	print(get_tree().network_peer.get_connection_status())


func isServerWithPilot():
	return server and pilotOn


func isPilot():
	return _connected and client and pilot_peer_id == get_tree().get_network_unique_id()
