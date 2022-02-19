tool
extends PopochiuRoom

onready var _neard_id: Label = find_node('NearId')
onready var _btn_edit: Button = find_node('BtnEdit')
onready var _adn: RichTextLabel = find_node('Adn')
onready var _name: RichTextLabel = find_node('Name')
onready var _turns_to_play: RichTextLabel = find_node('TurnsToPlay')
onready var _famous_quote: RichTextLabel = find_node('FamousQuote')
onready var _score: Label = find_node('score')
onready var _game_data_tabs: TabContainer = find_node('GameDataTabs')
onready var _completion_percent: Label = find_node('CompletionPercent')
onready var _narration: RichTextLabel = find_node('Narration')
onready var _btn_twitch: Button = find_node('BtnTwitch')
onready var _in_line_players: Label = find_node('InLinePlayers')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_game_data_tabs.set_tab_title(0, 'collection')
	_game_data_tabs.set_tab_title(1, 'game log')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	G.hide_interface()


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
