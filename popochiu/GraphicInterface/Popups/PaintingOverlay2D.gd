extends "res://popochiu/Common/Overlay2D.gd"

export(String) var code := '44cbglhndionnnpmjnonhnpndnmjnnnkjf' setget _set_code

func _ready():
	$Links.connect('puzzle_loaded', self, '_on_puzzle_loaded')
	_set_code(code)


func appear() -> void:
	$Camera2D.limit_left = E.main_camera.limit_left
	$Camera2D.limit_right = E.main_camera.limit_right
	global_position = E.main_camera.get_camera_position()
	$Camera2D.current = true
	.appear()


func display_paint(normal: Texture, hidden: Texture, key := 'LINK_PUZZLE_KEY_DEFAULT'):
	if not normal: return
	
	$Normal.texture = normal
	$Hidden.texture = hidden
	var display_hidden = I.active and I.active.script_name == 'MagicGlasses'
	
	# load secret puzzle configuration
	SecretsKeeper.async_get(key)
	var code = yield(SecretsKeeper, 'secret_retrieved')
	_set_code(code)
	
	if display_hidden:
		show_hidden(true)
		I.set_active_item(null, false)
	else:
		show_hidden(false)
	
	appear()


func show_hidden(_is_visible):
	$Hidden.visible = _is_visible
	$Links.visible = _is_visible


func disappear():
	$Camera2D.current = false
	E.main_camera.current = true
	.disappear()


func _set_code(value: String) -> void:
	code = value
	if $Links:
		$Links.load_level(code)
	property_list_changed_notify()


func _on_puzzle_loaded():
	$Links.position.x = -$Links.get_puzzle_width()*15/2
	$Links.position.y = -$Links.get_puzzle_height()*15/2

