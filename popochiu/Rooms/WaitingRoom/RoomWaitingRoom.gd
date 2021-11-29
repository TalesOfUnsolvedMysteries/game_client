tool
extends PopochiuRoom

var _messages := [
	'Welcome to [color=#E03C28]The bug adventure show[/color]',
	'Left click to interact.',
	'Right click to look.',
	'Find the way to the penthouse',
	'You have five minutes to play',
	'Take notes and share them',
	'Collab to resolve all the puzzles',
	'And die a lot of times...',
	'Bzzzzz bzzzzz bzzzzzz',
	'\\(>  o)/'
]
var _current := 0
var _messages_loop = true

onready var _screen: Prop = get_prop('Screen')
onready var _screen_yours: Prop = get_prop('ScreenYours')
onready var _turn: Label = _screen_yours.find_node('Number')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	WebsocketManager.connect('turn_assigned', self, '_on_turn_assigned')
	NetworkManager.connect('pilot_engaged', self, '_start_countdown')
	if WebsocketManager.turn > 0:
		_turn.text = '%d' % WebsocketManager.turn
	else:
		_turn.text = '???'
	
	if OS.has_feature('editor'):
		Console.add_command('start', self, '_dev_start').register()


func _exit_tree() -> void:
	if OS.has_feature('editor'):
		Console.remove_command('start')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	G.done()


func on_room_transition_finished() -> void:
	yield(E.run([
		'....',
		C.player_walk_to(get_point('BugEntry')),
	]), 'completed')
	
	_next_message()
	
	# TODO: ¿Esto debería ocurrir en base a una señal del servidor o algo así?
	yield(get_tree().create_timer(10.0), 'timeout')
	
	_enter_cohost()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _next_message() -> void:
	_screen.show_message(_messages[_current])
	
	yield(get_tree().create_timer(6.0), 'timeout')
	
	_current = wrapi(_current + 1, 0, _messages.size())
	if _messages_loop: _next_message()


func _enter_cohost() -> void:
	yield(E.run([
		C.character_walk_to('CoHost', get_point('CoHostEntry')),
		'..',
		C.player_walk_to(get_point('BugEntry')),
	]), 'completed')
	
	yield(D.show_dialog('Welcome'), 'completed')
	yield(D.show_dialog('Motivation'), 'completed')
	yield(D.show_dialog('Expectations'), 'completed')
	yield(D.show_dialog('Parents'), 'completed')
	yield(D.show_dialog('Farewell'), 'completed')
	
	yield(E.run([
		'CoHost: Well [color=#0a89ff]%s[/color].' % Globals.bug_name,
		'CoHost: I wish you luck!',
	]), 'completed')
	
	NetworkManager.set_ready_to_pilot(true)


func _on_turn_assigned(turn_value):
	_turn.text = '%d' % int(turn_value)


func _start_countdown():
	_messages_loop = false
	_screen.show_message('ready!')
	yield(get_tree().create_timer(3.0), 'timeout')
	_screen.show_message('3')
	yield(get_tree().create_timer(1.0), 'timeout')
	_screen.show_message('2')
	yield(get_tree().create_timer(1.0), 'timeout')
	_screen.show_message('1')
	yield(get_tree().create_timer(1.0), 'timeout')
	_screen.show_message('go!')
	
	yield(E.run([
		C.player_walk_to(get_point('Exit'))
	]), 'completed')


func _dev_start() -> void:
	yield(_start_countdown(), 'completed')
	E.goto_room('Lobby')
