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
	WebsocketManager.connect('userID_assigned', self, '_userID_assigned')
	WebsocketManager.connect('turn_assigned', self, '_turn_assigned')
	$Control/Screenshot.connect('pressed', Utils, 'take_screenshot', ['./test.png'])
	$Control/Join.connect('pressed', WebsocketManager, 'request_join')

func _player_connected(peer_id):
	$Control/Connection.text = 'Connection Status: connected'
	$Control/PeerID.text = 'peerID: %d' % peer_id

func _player_disconnected():
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

func _process(delta):
	if time > 0:
		time -= delta
		$Control/Countdown.text = 'time left: %ds' % int(time)
