tool
extends PopochiuRoom

var _placeholder := 'bug name'

onready var _gi: CanvasLayer = $GraphicInterface
onready var _head_selector: AttributeSelector = _gi.find_node('Head')
onready var _body_selector: AttributeSelector = _gi.find_node('Body')
onready var _legs_selector: AttributeSelector = _gi.find_node('Legs')
onready var _btn_idle: Button = _gi.find_node('Idle')
onready var _btn_walk: Button = _gi.find_node('Walk')
onready var _btn_done: Button = _gi.find_node('Done')
onready var _name_edit: LineEdit = _gi.find_node('NameEdit')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	C.player.set_part(_head_selector)
	C.player.set_part(_body_selector)
	C.player.set_part(_legs_selector)
	
	_btn_idle.connect('pressed', C.player, 'idle', [false])
	_btn_walk.connect('pressed', C.player, 'play_walk', [0.5])
	_btn_done.connect('pressed', self, '_start')
	_name_edit.connect('focus_entered', self, '_check_placeholder')
	_name_edit.connect('text_changed', self, '_check_bug_name')
	
	_name_edit.text = _placeholder
	_btn_done.disabled = true


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	pass


func on_room_transition_finished() -> void:
	G.done()
	G.hide_interface()


func on_room_exited() -> void:
	C.player.ready_to_play()
	.on_room_exited()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_placeholder() -> void:
	if _name_edit.text == _placeholder:
		_name_edit.clear()


func _check_bug_name(new_text: String) -> void:
	if not new_text or new_text == _placeholder:
		_btn_done.disabled = true
	else:
		_btn_done.disabled = false


func _start() -> void:
	Globals.bug_name = _name_edit.text
	E.goto_room('Lobby')
	#E.goto_room('BugCard')
