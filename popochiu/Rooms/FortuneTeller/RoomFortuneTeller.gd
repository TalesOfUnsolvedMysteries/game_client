tool
extends PopochiuRoom

const Figurine = preload('res://popochiu/Rooms/FortuneTeller/Props/Totem/PropFigurine.gd')
var figurine_a: Figurine = null
onready var secret: Secret = find_node('Secret')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	secret.connect('solved', self, '_on_solved')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	A.play({cue_name = 'sfx_door_close',is_in_queue = false})


func on_room_transition_finished() -> void:
	E.run([
		'Player: This place gives me the creeps...'
	])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados

func _exchange_figurines(_figurine_a: Figurine, _figurine_b: Figurine):
	var _config: String = Globals.state.get('RITUAL_configuration')
	_figurine_a.unselect()
	figurine_a = null
	var swap_position = _figurine_a.position
	_figurine_a.position = _figurine_b.position
	_figurine_b.position = swap_position
	_config = _config.replace(_figurine_a.totem_symbol, 'Z')
	_config = _config.replace(_figurine_b.totem_symbol, _figurine_a.totem_symbol)
	_config = _config.replace('Z', _figurine_b.totem_symbol)
	Globals.set_state('RITUAL_configuration', _config)

	
func toggle_figurine(figurine_prop: Figurine):
	if figurine_a == null:
		figurine_a = figurine_prop
		figurine_prop.select()
	elif figurine_a == figurine_prop:
		figurine_a = null
		figurine_prop.unselect()
	else:
		_exchange_figurines(figurine_a, figurine_prop)
	
func start_ritual():
	var _config: String = Globals.state.get('RITUAL_configuration')
	print('check current %s to invoke' % _config)
	# animation to start the summon
	secret.solve('')

func known_summon(room: String):
	# animation to appears
	yield(E.run([
		'Player: this is the spirit from %s' % room
	]), 'completed')

func _on_solved(solved):
	if solved is bool:
		# animation to dissapear
		yield(E.run([
			'Player: Nothing happened...'
		]), 'completed')
	else:
		if solved[0] == 'A': # already solved
			solved = solved.replace('A', '')
		else: # first time solved
			yield(G, 'nft_shown')
		self.known_summon(solved)

