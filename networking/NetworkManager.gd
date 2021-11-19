extends Node

const SERVER_PORT = 7333
const MAX_PLAYERS = 255

func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnected')
	self._pass_arguments()

func _pass_arguments():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	
	if arguments.has('server') and arguments.get('server'):
		init_server()
	else:
		request_join('54.82.26.60', SERVER_PORT)

func init_server():
	print('initializating server')
	var net = NetworkedMultiplayerENet.new()
	net.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = net
	print('server started with peer: ', get_tree().get_network_unique_id())

func request_join(server_ip, server_port):
	print('connecting to the server...')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, server_port)
	get_tree().network_peer = peer

# server and client
func _player_connected(player_id):
	print('should register players connected to the game ', player_id)

# server and client
func _player_disconnected(player_id):
	print('should register what players get disconected ', player_id)

# client
func _connected_ok():
	print('connection successful')

# client
func _connected_fail():
	print('connection fail')

# client - most probably server kicked this player
func _server_disconnected():
	print('server is down')
	print(get_tree().has_network_peer())
	print(get_tree().network_peer.get_connection_status())

