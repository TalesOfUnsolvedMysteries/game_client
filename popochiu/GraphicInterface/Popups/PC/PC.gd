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

var usb_id = 0 # track which usb is requested

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

func show():
	.show()
	var _navigator_app = find_node('Navigator')
	var _navigator2_app = find_node('Usb2')
	_navigator_app.hide()
	_navigator2_app.hide()
	if Globals.state.get('Lobby-USB_IN_PC', false):
		_navigator_app.show()
		#Globals.set_state('PC_ELEVATOR_APP_VERSION', 2)
		#Globals.set_state('Lobby-USB_IN_PC', false)
		#find_node('Elevator').set_elevator_version(2)
		#show_popup('w', 'elevator program updated succesfuly', self)
	
	if Globals.state.get('LOBBY-USB2_IN_PC', false):
		_navigator2_app.show()
		#Globals.set_state('PC_REGISTER_APP_INSTALLED', true)
		#show_popup('w', 'register program installed succesfuly', self)
	_check_new_apps()

func _check_new_apps():
	find_node('Register').visible = Globals.state.get('PC_REGISTER_APP_INSTALLED', false)
	find_node('Elevator').set_elevator_version(Globals.state.get('PC_ELEVATOR_APP_UPDATED', false))
		

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
			if _app_container.get_child_count() > 0: _close_app()
			Utils.invoke(self, 'hide')


func _on_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))


func _notify_popup_close() -> void:
	_overlay.hide()
	
	if is_instance_valid(_opened_app) and _opened_app.has_method('on_popup_closed'):
		_opened_app.on_popup_closed()


func _load_app(app: Panel, extra: String) -> void:
	_app_container.add_child(app)
	app.extra = extra
	app.OS = self
	app.connect('close_requested', Utils, 'invoke', [self, '_close_app'])
	A.play({cue_name = 'sfx_pc_app_open',is_in_queue = false})
	_app_screen.show()


func _close_app() -> void:
	var app = _app_container.get_child(_app_container.get_child_count() - 1)
	yield(app.dispose(), 'completed')
	app.queue_free()
	if _app_container.get_child_count() == 1:
		_app_screen.hide()
		_check_new_apps()
