tool
extends PopochiuRoom

onready var _adn_analyzer: PanelContainer = find_node('ADNAnalyzer')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_adn_analyzer.connect('closed', get_prop('DoctorPC'), 'on_analyzer_closed')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	A.play({cue_name = 'sfx_door_close',is_in_queue = false})


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func turn_on_analyzer(adn_sample := '') -> void:
	_adn_analyzer.appear(adn_sample)
