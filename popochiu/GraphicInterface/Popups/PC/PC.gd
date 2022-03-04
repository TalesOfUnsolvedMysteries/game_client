extends PanelContainer
# La computadora que se encuentra en el Lobby del edificio y que da acceso a
# las aplicaciones de registro, progreso y programación de comportamiento del
# ascensor.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

var _opened_app: Control = null

onready var _thanks: RichTextLabel = find_node('Thanks')
onready var _os_popup: PanelContainer = find_node('OSPopup')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	_thanks.connect('meta_clicked', self, '_on_meta_clicked')
	_os_popup.connect('closed', self, '_notify_popup_close')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_popup(type: String, message: String, origin: Control) -> void:
	_opened_app = origin
	_os_popup.show_popup(type, message)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			Utils.invoke(self, 'hide')


func _on_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))


func _notify_popup_close() -> void:
	if is_instance_valid(_opened_app):
		_opened_app.on_popup_closed()
