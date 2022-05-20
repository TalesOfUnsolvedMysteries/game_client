tool
extends PanelContainer

export(Array, Dictionary) var code := [] setget _set_code


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if Engine.editor_hint: return
	
	if code:
		var code_dic := {}
		for dic in code:
			code_dic[dic.pos] = dic.chr
		$Password.setup(code_dic)
	
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear(normal: Texture, hidden: Texture) -> void:
	if not normal: return
	
	$Normal.texture = normal
	$Hidden.texture = hidden
	
	if I.active and I.active.script_name == 'MagicGlasses':
		show_hidden(true)
	else:
		show_hidden(false)
	
	show()


func disappear() -> void:
	Utils.invoke(self, '_close')


func show_hidden(is_visible: bool) -> void:
	$Hidden.visible = is_visible
	$Password.visible = is_visible


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()


func _close():
	hide()


func _set_code(value: Array) -> void:
	code = value
	
	for idx in value.size():
		if not value[idx]:
			code[idx] = {
				pos = '',
				chr = '',
			}
			
			property_list_changed_notify()
