extends PanelContainer

signal closed()

onready var collected_list = find_node('Collected')
onready var scanned_list = find_node('Scanned')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	load_data()
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	show()


func disappear() -> void:
	Utils.invoke(self, '_close')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()

func load_data():
	var _collected_adn = Globals.state.get('Killertron_COLLECTED_ADN')
	var _scanned_adn = Globals.state.get('Killertron_SCANNED_ADN')
	var _total_scanned = Globals.state.get('Killertron_TOTAL_SCANNED')
	
	# load collected adn
	var i = 0
	for _adn in _collected_adn:
		var _label = collected_list.get_child(i + 1)
		_label.bbcode_text = '[center]0%d %s[/center]' % [i, _adn]
		_label.visible = true
		i += 1
	
	# load scanned list
	i = 0
	for _adn in _scanned_adn:
		var _label = scanned_list.get_child(i + 1)
		_label.bbcode_text = '[center]%03d %s[/center]' % [_total_scanned - i - 1, _decorate_adn_scan(_adn)]
		_label.visible = true
		i += 1

func _decorate_adn_scan(scanned_adn):
	var adn = scanned_adn[0]
	var matches = scanned_adn[1]
	var decorated_text = ''
	var i = 0
	for gene in adn:
		var color = '#ff0000'
		match matches[i]:
			'1': color = '#ffff00'
			'2': color = '#00ff00'
		decorated_text += '[color=%s]%s[/color]' % [color, gene]
		i += 1
	return decorated_text

func _close():
	emit_signal('closed')
	Cursor.set_cursor()
	G.show_info()
	hide()

