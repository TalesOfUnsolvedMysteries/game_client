extends PanelContainer
# Controla la lógica de los popups del sistema operativo chimbo del computador.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

signal closed

export var icon_warning: Texture = null
export var icon_error: Texture = null

onready var _title: Label = find_node('Title')
onready var _icon: TextureRect = find_node('Icon')
onready var _message: Label = find_node('Message')
onready var _close: Button = find_node('BtnClose')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_close.connect('pressed', Utils, 'invoke', [self, '_close'])
	_close.connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	_close.connect('mouse_exited', Cursor, 'set_cursor')
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_popup(type: String, message: String) -> void:
	match type:
		'warning', 'w':
			_title.text = 'warning'
			_icon.texture = icon_warning
		'error', 'e':
			_title.text = 'error'
			_icon.texture = icon_error
	
	_message.text = message
	
	show()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _close() -> void:
	emit_signal('closed')
	hide()
