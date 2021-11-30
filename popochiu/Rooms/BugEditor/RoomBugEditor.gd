tool
extends PopochiuRoom

var _placeholder := 'bug name'

onready var _gi: CanvasLayer = $GraphicInterface
onready var _selectors := [
	_gi.find_node('Head'),
	_gi.find_node('Body'),
	_gi.find_node('Legs'),
	_gi.find_node('Eyes'),
	_gi.find_node('Clothes'),
	_gi.find_node('Shoes')
]
onready var _btn_idle: Button = _gi.find_node('Idle')
onready var _btn_walk: Button = _gi.find_node('Walk')
onready var _btn_done: Button = _gi.find_node('Done')
onready var _name_edit: LineEdit = _gi.find_node('NameEdit')

onready var _user_id: Label = _gi.find_node('UserId')

var _user_ready = false

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_update_adn()
	
	for s in _selectors:
		(s as AttributeSelector).connect('part_updated', self, '_update_adn')
	_btn_idle.connect('pressed', C.player, 'idle', [false])
	_btn_walk.connect('pressed', C.player, 'play_walk', [0.5])
	_btn_done.connect('pressed', self, '_start')
	_name_edit.connect('focus_entered', self, '_check_placeholder')
	_name_edit.connect('text_changed', self, '_check_bug_name')
	
	_name_edit.text = _placeholder
	_btn_done.disabled = true

	WebsocketManager.connect('userID_assigned', self, '_userID_assigned')
	_user_ready = WebsocketManager.user_id != 0
	if _user_ready:
		_user_id.text = 'Player %d' % WebsocketManager.user_id


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	C.player.position = Vector2(0, 0)
	Globals.set_appearance('000xxx')


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
	if not _user_ready or not new_text or new_text == _placeholder:
		_btn_done.disabled = true
	else:
		_btn_done.disabled = false


func _start() -> void:
	Globals.bug_name = _name_edit.text
	WebsocketManager.send_message_ws('setBugName:%s' % Globals.bug_name)
	WebsocketManager.send_message_ws('setADN:%s' % Globals.bug_adn)
	WebsocketManager.request_turn()
	E.goto_room('WaitingRoom')
	#E.goto_room('BugCard')


func _userID_assigned(user_id):
	print('user id assigned %d' % user_id)
	_user_ready = user_id != 0
	_user_id.text = 'Player %d' % user_id
	_check_bug_name(_name_edit.text)


func _update_adn(node: AttributeSelector = null) -> void:
	var adn := ''
	for s in _selectors:
		var idx := (s as AttributeSelector).get_part_idx()
		adn += str(idx) if idx > -1 else 'x'
	Globals.set_appearance(adn)
