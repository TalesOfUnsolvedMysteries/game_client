tool
extends PopochiuRoom

onready var _status: Label = find_node('Status')
onready var _join_btn: Button = find_node('Join')
onready var _player: Label = find_node('Player')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta
func _ready():
	ServerConnection.connect('connection_updated', self, '_on_connection_updated')
	ServerConnection.connect('userID_assigned', self, '_userID_assigned')
	_join_btn.connect('button_down', self, '_on_join')

	_on_connection_updated(ServerConnection.status)
	_userID_assigned(ServerConnection.user_id)

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
		ServerConnection.CONNECTION_STATUS.OFFLINE:
			_status.text = 'not connected to server'
		ServerConnection.CONNECTION_STATUS.CONNECTING:
			_status.text = 'connecting to the server'
		ServerConnection.CONNECTION_STATUS.RECOVERING_CREDENTIALS:
			_status.text = 'recovering existing session'
		ServerConnection.CONNECTION_STATUS.CREDENTIALS_RECOVERED:
			_userID_assigned(ServerConnection.user_id)
			_status.text = 'connected as player #%d' % ServerConnection.user_id
			_join_btn.disabled = false
		ServerConnection.CONNECTION_STATUS.ESTABLISHED:
			_status.text = 'connection established'
		ServerConnection.CONNECTION_STATUS.HANDSHAKING:
			_status.text = 'validating connection'
		ServerConnection.CONNECTION_STATUS.CONNECTED:
			_status.text = 'online'
			_join_btn.disabled = false
		ServerConnection.CONNECTION_STATUS.REJECTED:
			_status.text = 'on line '
			_join_btn.disabled = false
		ServerConnection.CONNECTION_STATUS.ERROR:
			_status.text = 'error on connection'
		ServerConnection.CONNECTION_STATUS.CLOSED:
			_status.text = 'connection closed'

func _userID_assigned(player_id):
	_player.text = 'Player: #%d' % player_id
	_player.show()

func _on_join():
	_join_btn.disabled = true
	if ServerConnection.user_id != 0:
		_status.text = 'continue...'
		E.goto_room('MainMenu')
		return
	_status.text = 'registering new user on Blockchain'
	yield(ServerConnection.request_user_session(), 'completed')
	E.goto_room('BugEditor')

