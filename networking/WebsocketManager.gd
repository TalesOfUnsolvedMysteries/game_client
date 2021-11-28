extends Node2D

# The URL we will connect to
export var websocket_url = "ws://localhost:8080"
#export var websocket_url = "ws://54.196.243.17:7334"

# Our WebSocketClient instance
var wsClient = WebSocketClient.new()
var secret_key = 'XZA' # generate random one

var user_file = "user://user.save"
var user_id = '0' setget set_user_id
var password = '' setget set_password
var server_request = false
signal userID_assigned
signal turn_assigned

func _ready():
	randomize()
	# connection to ws
	# Connect base signals to get notified of connection open, close, and errors.
	wsClient.connect("connection_closed", self, "_closed")
	wsClient.connect("connection_error", self, "_closed")
	wsClient.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	wsClient.connect("data_received", self, "_on_data")
	self._pass_arguments()

func _pass_arguments():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	
	if arguments.has('secret_key'):
		secret_key = arguments.get('secret_key')
	
	var server_request = arguments.has('server') and arguments.get('server')
	init(server_request)

func init(_server_request):
	# Initiate connection to the given URL.
	load_user_data()
	server_request = _server_request
	var err = wsClient.connect_to_url(websocket_url)
	print (err)
	if err != OK:
		print("Unable to connect")

func save_user ():
	var file = File.new()
	file.open(user_file, File.WRITE)
	file.store_string('%s %s' % [user_id, password])
	file.close()


func load_user_data ():
	var file = File.new()
	if file.file_exists(user_file):
		file.open(user_file, File.READ)
		var data = file.get_as_text().split(' ')
		user_id = data[0]
		password = data[1]
		file.close()
	else:
		password = Utils.generate_word(16)


func register_game_server():
	send_message_ws('registerGameServer:%s' % secret_key)

# was_clean will tell you if the disconnection was correctly notified
# by the remote peer before closing the socket.
func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)

# This is called on connection, "proto" will be the selected WebSocket
# sub-protocol (which is optional)
func _connected(proto = ""):
	print("Connected with protocol: ", proto)

# Print the received packet, you MUST always use get_peer(1).get_packet
# to receive data from server, and not get_packet directly when not
# using the MultiplayerAPI.
func _on_data():
	var message: String = wsClient.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", message)
	var split = message.split(':')
	var command = split[0]
	var data = split[1]
	if command == 'connecting':
		var reply = 'ack:' + data
		send_message_ws(reply)
	elif command == 'connected':
		print('connected to the server')
		if server_request: NetworkManager.init_server()
		else:
			if user_id != '0':
				send_message_ws('recoverSession:%s--%s' % [user_id, password])
	elif command == 'userRecoveryFails':
		print('user recovery fails')
	elif command == 'userRecovered':
		var splittedData = data.split('-')
		var userId = int(splittedData[0])
		var turn = int(splittedData[1])
		set_user_id(userId)
		if turn > 0:
			emit_signal('turn_assigned', turn)
		else:
			send_message_ws('requestTurn')
	elif command == 'userAssigned':
		set_user_id(data)
		save_user()
		send_message_ws('requestTurn')
	elif command == 'ping':
		send_message_ws('pong')
	elif command == 'replyTurn':
		print('turn assigned', data)
		emit_signal('turn_assigned', data)
	elif command == 'gc_connect':
		join_client(data)
	elif command == 'gs_connected':
		if !NetworkManager.server: return
		send_message_ws('gs_ready')
	elif command == 'gs_waitForConnection':
		if !NetworkManager.server: return
		# save the secret key and wait for a player ask for connection using it
		secret_key = data
		send_message_ws('gs_waitingConnection:%s' % secret_key)
	elif command == 'gs_assignPilot':
		if !NetworkManager.server: return
		NetworkManager.set_pilot(int(data))
	elif command == 'gs_generateCard':
		if !NetworkManager.server: return
		var _filename = '%s.png' % data
		E.goto_room('BugCard')
		yield(get_tree().create_timer(2), 'timeout')
		Utils.take_screenshot(_filename)
		yield(get_tree().create_timer(1), 'timeout')
		send_message_ws('gs_cardGenerated:%s' % _filename)
		# TODO 
		# restore game to allow a new player - moves to another scene?
		E.goto_room('WaitingRoom')

var max_interval = 1/20
var delta_acc = 0

# Call this in _process or _physics_process. Data transfer, and signals
# emission will only happen when calling this function.
func _process(delta):
	wsClient.poll()
	if NetworkManager.server:
		delta_acc += delta
		#$Icon.position = get_local_mouse_position()
		if (delta_acc >= max_interval):
			delta_acc -= max_interval
			#rset_unreliable("icon_position", $Icon.position)
			#print('algo desde el server')
	if NetworkManager.client:
		#$Icon.position = icon_position
		#print('algo en el cliente')
		pass

func send_message_ws(message):
	wsClient.get_peer(1).put_packet(message.to_utf8())


func join_client(_secret_key):
	NetworkManager.request_join('localhost')
#	NetworkManager.request_join('54.196.243.17')
	secret_key = _secret_key
	print('secret key saved on client %s' % _secret_key)
	#rpc_id(1, "validate_connection", '#otra cosa')

remote func player_joined(message):
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	print(message)
	if !NetworkManager.server:
		print('sending private key message: %s' % secret_key)
		rpc_id(1, "validate_connection", secret_key)


func player_connected(player_id):
	rpc_id(player_id, 'player_joined', 'hola')

func player_disconnect(peer_id):
	send_message_ws('gs_player_disconnected:%d' % peer_id)

remote func validate_connection(_secret_key):
	var id = get_tree().get_rpc_sender_id()
	if secret_key != _secret_key:
		get_tree().network_peer.disconnect_peer(id)
		send_message_ws('gs_connectionFail:%s' % secret_key)
	else:
		print ('connection successful')
		send_message_ws('gs_connectionSuccess:%s-%d' % [secret_key, id])

func request_join():
	# generate random word or phrase save on local storage and send it to the server
	send_message_ws('allocateUser:%s' % password)


func set_user_id(_user_id):
	user_id = _user_id
	emit_signal('userID_assigned', user_id)
	
func set_password(_password):
	password = _password

