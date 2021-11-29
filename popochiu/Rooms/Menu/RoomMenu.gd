tool
extends PopochiuRoom

onready var _status: Label = find_node('Status')
onready var _join_btn: Button = find_node('Join')
onready var _player: Label = find_node('Player')
onready var _UserId_label: Label = find_node('UserId')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta
func _ready():
	WebsocketManager.connect('connection_updated', self, '_on_connection_updated')
	WebsocketManager.connect('userID_assigned', self, '_userID_assigned')
	_join_btn.connect('button_down', self, '_on_join')

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
	_UserId_label.text = '%d' % player_id
	_join_btn.text = 'Continue'
	_UserId_label.show()
	_player.show()

func _on_join():
	WebsocketManager.request_join()
	_status.text = 'joining to the show'
	E.goto_room('BugEditor')
