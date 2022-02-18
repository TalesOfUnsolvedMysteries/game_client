extends CanvasLayer

var time = 0
func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnected')
	NetworkManager.connect('server_started', self, '_server_started')
	NetworkManager.connect('control_taken', self, '_control_taken')
	NetworkManager.connect('control_lost', self, '_control_lost')
	ServerConnection.connect('userID_assigned', self, '_userID_assigned')
	ServerConnection.connect('turn_assigned', self, '_turn_assigned')
	$Control/Screenshot.connect('pressed', Utils, 'take_screenshot', ['./test.png'])
	$Control/Join.connect('pressed', ServerConnection, 'request_user_session')
	$Control/Clean.connect('pressed', self, 'clean_console')

func _player_connected(peer_id):
	$Control/Connection.text = 'Connection Status: connected'
	$Control/PeerID.text = 'peerID: %d' % peer_id

func _player_disconnected(player_id):
	$Control/Connection.text = 'Connection Status: disconnected'

func _connected_ok():
	$Control/Connection.text = 'Connection Status: connected to the server'

func _connected_fail():
	$Control/Connection.text = 'Connection Status: failed'

func _server_disconnected():
	$Control/Connection.text = 'Connection Status: server disconnected'

func _server_started():
	$Control/Connection.text = 'Connection Status: server'
	$Control/UserID.hide()

func _control_taken():
	$Control/Connection.text = 'Connection Status: Pilot!'
	time = 30

func _control_lost():
	$Control/Connection.text = 'Connection Status: connected'

func _userID_assigned(userID):
	$Control/UserID.text = 'userId: %s' % userID

func _turn_assigned(turn):
	$Control/Turn.text = 'turn: %s' % turn

func clean_console():
	$Control/Log.text = ''

func _process(delta):
	if time > 0:
		time -= delta
		#$Control/Countdown.text = 'time left: %ds' % int(time)


func _get_request(url):
	var result = yield(ServerConnection._get_request(url), 'completed')
	$Control/Log.text = $Control/Log.text + '\n' + JSON.print(result)


