tool
extends PopochiuRoom

onready var _status: Label = find_node('Status')
onready var _join_btn: Button = find_node('Join')
onready var _player: Label = find_node('Player')

var wallet_connection

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta
func _ready():
	WebsocketManager.connect('connection_updated', self, '_on_connection_updated')
	WebsocketManager.connect('userID_assigned', self, '_userID_assigned')
	_join_btn.connect('button_down', self, '_on_join')
	
	if OS.has_feature('web'):
		$MainMenu/Control/Extra.show()
	
	# test NEAR connection
	var config = {
		"network_id": "testnet",
		"node_url": "https://rpc.testnet.near.org",
		"wallet_url": "https://wallet.testnet.near.org",
	}
	Near.start_connection(config)
	wallet_connection = WalletConnection.new(Near.near_connection)
	var result = Near.call_view_method("dev-1643248303417-39450742687599", "getLine")
	if result is GDScriptFunctionState:
		result = yield(result, "completed")
	if result.has("error"):
		print(result)
		pass # Error handling here
	else:
		var data = result.data
		print(data)
	#wallet_connection.sign_in("dev-1643248303417-39450742687599")
	#yield(wallet_connection, "user_signed_in")
	#print('se conecto?')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	G.done()
	G.hide_interface()


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
func _on_connection_updated(connection_status):
	_join_btn.disabled = true
	
	match connection_status:
		WebsocketManager.CONNECTION_STATUS.OFFLINE:
			_status.text = 'not connected to server'
		WebsocketManager.CONNECTION_STATUS.CONNECTING:
			_status.text = 'connecting to the server'
		WebsocketManager.CONNECTION_STATUS.RECOVERING_CREDENTIALS:
			_status.text = 'recovering existing session'
		WebsocketManager.CONNECTION_STATUS.ESTABLISHED:
			_status.text = 'connection established'
		WebsocketManager.CONNECTION_STATUS.HANDSHAKING:
			_status.text = 'validating connection'
		WebsocketManager.CONNECTION_STATUS.CONNECTED:
			_status.text = 'online'
			_join_btn.disabled = false
		WebsocketManager.CONNECTION_STATUS.REJECTED:
			_status.text = 'on line '
			_join_btn.disabled = false
		WebsocketManager.CONNECTION_STATUS.ERROR:
			_status.text = 'error on connection'
		WebsocketManager.CONNECTION_STATUS.CLOSED:
			_status.text = 'connection closed'

func _userID_assigned(player_id):
	_player.text = 'Player: #%d' % player_id
	_join_btn.text = 'Continue'
	_player.show()

func _on_join():
	if not OS.has_feature('web'):
		WebsocketManager.request_join()
		_status.text = 'joining to the show'
	E.goto_room('BugEditor')

