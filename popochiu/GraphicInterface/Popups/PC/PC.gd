extends PanelContainer
# La computadora que se encuentra en el Lobby del edificio y que da acceso a
# las aplicaciones de registro, progreso y programación de comportamiento del
# ascensor.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

var _opened_app: Control = null

onready var _thanks: RichTextLabel = find_node('Thanks')
onready var _overlay: MarginContainer = find_node('Overlay')
onready var _os_popup: PanelContainer = find_node('OSPopup')
onready var _apps: GridContainer = find_node('Apps')
onready var _app_screen: MarginContainer = find_node('AppScreen')
onready var _app_container: PanelContainer = find_node('AppContainer')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	_thanks.connect('meta_clicked', self, '_on_meta_clicked')
	_os_popup.connect('closed', self, '_notify_popup_close')
	for i in _apps.get_children():
		i.connect('app_opened', self, '_load_app')
	
	_app_screen.hide()
	_overlay.hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_popup(type: String, message: String, origin: Control) -> void:
	_opened_app = origin
	_overlay.show()
	A.play({cue_name = 'sfx_pc_error',is_in_queue = false})
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
	_overlay.hide()
	
	if is_instance_valid(_opened_app):
		_opened_app.on_popup_closed()


func _load_app(app: Panel) -> void:
	_app_container.add_child(app)
	app.OS = self
	(app.get_node('BtnClose') as TextureButton).connect(
		'pressed', Utils, 'invoke', [self, '_close_app']
	)
	A.play({cue_name = 'sfx_pc_app_open',is_in_queue = false})
	_app_screen.show()


func _close_app() -> void:
	_app_container.get_child(0).queue_free()
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	_app_screen.hide()
