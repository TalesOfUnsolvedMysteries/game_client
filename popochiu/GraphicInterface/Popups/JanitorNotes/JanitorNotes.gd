extends Panel

var _drawings := {}


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	for d in $KeysDrawings.get_children():
		var drawing: HBoxContainer = d
		var config: String = SecretsKeeper.get('DOOR_%s_LOCK' % drawing.name)
		
		if not config:
			config = '0' + drawing.name
		
		for part in range(1, drawing.get_child_count()):
			var part_texture: AtlasTexture =\
			(drawing.get_child(part) as TextureRect).texture
			
			part_texture.region.position.x = int(config[part - 1]) * 14
	
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
#	_set_key_config(Globals.state['MasterKey-CONFIG'])

	show()


func disappear() -> void:
	Utils.invoke(self, '_close')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()


func _close():
	Cursor.set_cursor()
	G.show_info()
	hide()
