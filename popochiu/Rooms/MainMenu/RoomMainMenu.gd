tool
extends PopochiuRoom

onready var _neard_id: Label = find_node('NearId')
onready var _btn_connect: Button = find_node('BtnConnect')
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
onready var _memories_container: MarginContainer = find_node('Memories')
onready var _memory_container: MarginContainer = find_node('MemoryContainer')
onready var _character = $Characters/CharacterBug

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_game_data_tabs.set_tab_title(0, 'collection')
	_game_data_tabs.set_tab_title(1, 'game log')
	_game_data_tabs.set_tab_disabled(1, true)
	
	_btn_edit.connect('button_down', self, '_on_click_edit')
	NetworkManager.connect('pilot_engaged', self, '_start_countdown')
	
	_character.hide()
	ServerConnection.connect('user_loaded', self, '_load_info')
	ServerConnection.get_user()
	
	_btn_connect.connect('button_down', self, '_on_connect_near')

func _load_info():
	var user_obj = ServerConnection.user_obj
	if user_obj.has('adn') and user_obj.adn:
		_adn.bbcode_text = 'adn: [color=#FFE737]%s[/color]' % user_obj.adn
		Globals.set_appearance(user_obj.adn)
		_character.show()
	
	if user_obj.has('bugName') and user_obj.bugName:
		_name.bbcode_text = 'name: [color=#FFE737]%s[/color]' % user_obj.bugName

	
	var wc = ServerConnection.wallet_connection
	if wc and wc.account_id:
		_neard_id.text = wc.account_id
		_neard_id.show()
		_btn_connect.hide()
	else:
		_btn_connect.show()
	#_score.text = '%d' % int(user_obj.score)
	var _turns = yield(ServerConnection.near_turns_to_play(), 'completed')
	if int(_turns) > 1000000:
		_turns_to_play.bbcode_text = 'requesting turn...'
	else:
		_turns_to_play.bbcode_text = 'turns to play: [color=#FFE737]%d[/color]' % int(_turns)
	if int(_turns) <= 1:
		NetworkManager.set_ready_to_pilot(true)
	#user_obj.userID
	#user_obj.state


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	G.done()
	G.hide_interface()
	yield(ServerConnection.request_turn(), 'completed')

func on_room_transition_finished() -> void:
	pass

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
func _show_memory():
	_memories_container.hide()
	_memory_container.show()

func _start_countdown():
	yield(get_tree().create_timer(3.0), 'timeout')
	yield(get_tree().create_timer(1.0), 'timeout')
	yield(get_tree().create_timer(1.0), 'timeout')
	yield(get_tree().create_timer(1.0), 'timeout')
	E.goto_room('Lobby')

func _on_click_edit():
	E.goto_room('BugEditor')

func _on_connect_near():
	_btn_connect.disabled = true
	yield(ServerConnection.connect_near(), 'completed')
	

