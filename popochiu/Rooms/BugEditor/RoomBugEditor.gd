tool
extends PopochiuRoom

onready var _gi: CanvasLayer = $GraphicInterface
onready var _head_selector: AttributeSelector = _gi.find_node('Head')
onready var _body_selector: AttributeSelector = _gi.find_node('Body')
onready var _legs_selector: AttributeSelector = _gi.find_node('Legs')
onready var _btn_idle: Button = _gi.find_node('Idle')
onready var _btn_walk: Button = _gi.find_node('Walk')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	C.player.set_part(_head_selector)
	C.player.set_part(_body_selector)
	C.player.set_part(_legs_selector)
	
	_btn_idle.connect('pressed', C.player, 'idle', [false])
	_btn_walk.connect('pressed', C.player, 'play_walk')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	pass


func on_room_transition_finished() -> void:
	G.done()
	G.hide_interface()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
