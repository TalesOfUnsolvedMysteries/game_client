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
	yield(get_tree().create_timer(15), "timeout")
	#$Screenshot.connect('pressed', Utils, 'take_screenshot')
	Utils.take_screenshot()

func _player_connected(peer_id):
	$Connection.text = 'Connection Status: connected'
	$PeerID.text = 'peerID: %d' % peer_id

func _player_disconnected():
	$Connection.text = 'Connection Status: disconnected'

func _connected_ok():
	$Connection.text = 'Connection Status: connected to the server'

func _connected_fail():
	$Connection.text = 'Connection Status: failed'

func _server_disconnected():
	$Connection.text = 'Connection Status: server disconnected'

func _server_started():
	$Connection.text = 'Connection Status: server'
	$UserID.hide()

func _control_taken():
	$Connection.text = 'Connection Status: Pilot!'
	time = 30

func _control_lost():
	$Connection.text = 'Connection Status: connected'

func _userID_assigned(userID):
	$UserID.text = 'userId: %s' % userID

func _turn_assigned(turn):
	$Turn.text = 'turn: %s' % turn

func _process(delta):
	if time > 0:
		time -= delta
		$Countdown.text = 'time left: %ds' % int(time)
