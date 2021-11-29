tool
extends PopochiuRoom

var _messages := [
	'Welcome to [color=#E03C28]The bug adventure show[/color]',
	'Left click to interact.',
	'Right click to look.',
	'Find the way to the penthouse',
	'You have five minutes to play',
	'Take notes and share them',
	'Collab to resolve all the puzles',
	'And die a lot of times...',
	'Bzzzzz bzzzzz bzzzzzz',
	'\\(>  o)/'
]
var _current := 0

onready var _screen: Prop = get_prop('Screen')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	pass


func on_room_transition_finished() -> void:
	yield(E.run([
		'....',
		C.player_walk_to(get_point('BugEntry')),
	]), 'completed')
	
	_next_message()
	
	# TODO: ¿Esto debería ocurrir en base a una señal del servidor o algo así?
	yield(get_tree().create_timer(10.0), 'timeout')
	
	yield(E.run([
		C.character_walk_to('CoHost', get_point('CoHostEntry')),
		'..',
		C.player_walk_to(get_point('BugEntry')),
		'CoHost: Hi [color=#0a89ff]%s[/color], Welcome to The Bug Adventure Show!'\
		% Globals.bug_name,
		"CoHost: I'm Pacheco. How do you feel?"
	]), 'completed')
	
	yield(D.show_dialog('Welcome'), 'completed')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _next_message() -> void:
	_screen.show_message(_messages[_current])
	
	yield(get_tree().create_timer(6.0), 'timeout')
	
	_current = wrapi(_current + 1, 0, _messages.size())
	_next_message()
