tool
extends PopochiuRoom

onready var _btn_replay: Button = find_node('BtnPlayAgain')
onready var _btn_connect: Button = find_node('BtnConnect')
onready var _container_near: VBoxContainer = find_node('NearContainer')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_btn_replay.connect('pressed', E, 'goto_room', ['Menu'])
	_btn_connect.connect('button_down', self, '_on_connect_near')
	_check_near_container()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	G.done()
	G.hide_interface()

	if Globals.main_mx_play:
		A.stop('mx_main', 0, false, true)
		Globals.main_mx_play = false


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados

func _check_near_container():
	var wc = ServerConnection.wallet_connection
	if wc and wc.account_id:
		_container_near.hide()
	else:
		_container_near.show()
		_btn_connect.disabled = false

func _on_connect_near():
	_btn_connect.disabled = true
	_btn_replay.disabled = true
	yield(ServerConnection.near_connector.connect_blockchain(), 'completed')
	_btn_replay.disabled = false
	_check_near_container()
