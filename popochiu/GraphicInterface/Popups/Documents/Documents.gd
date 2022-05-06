extends PanelContainer
# Muestra documentos paginados al estilo de Resident Evil 2 y Resident Evil 3.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

var _current_page := 0 setget _set_current_page
var _current_document := {}
var _total_pages := 0
var _move_time := 0.0
var _switch := true
var _from_right := true

onready var _btn_left: TextureButton = find_node('BtnLeft')
onready var _dflt_left_x := _btn_left.rect_position.x
onready var _type: TextureRect = find_node('Type')
onready var _btn_right: TextureButton = find_node('BtnRight')
onready var _dflt_right_x := _btn_right.rect_position.x
onready var _btn_exit: Button = find_node('BtnExit')
onready var _pages_counter: Label = find_node('PagesCounter')
onready var _content: Label = find_node('Content')
onready var _dflt_content_x := _content.rect_position.x


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	hide()
	
	# Conectarse a señales de los hijos
	_btn_left.connect('pressed', Utils, 'invoke', [self, '_prev_page'])
	_btn_right.connect('pressed', Utils, 'invoke', [self, '_next_page'])
	_btn_exit.connect('pressed', Utils, 'invoke', [self, '_close'])
	
	# Conectarse a señales de los singletones
	G.connect('documents_requested', self, 'show_documents')
	
	set_process(false)


func _process(delta: float) -> void:
	_move_time += delta
	
	if _move_time >= 0.5:
		_move_time = 0.0
		
		if not _btn_left.disabled:
			_btn_left.rect_position.x =\
			_dflt_left_x - 4.0 if _switch else _dflt_left_x
		
		_btn_right.rect_position.x =\
		_dflt_right_x + 4.0 if _switch else _dflt_right_x
		
		_switch = !_switch


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_documents(data: Dictionary) -> void:
	_current_document = data
	_total_pages = data.pages.size() - 1
	self._current_page = 0
	_type.texture = data.bg
	_pages_counter.visible = _total_pages > 0
	
	show()
	
	$Tween.interpolate_property(
		self, 'modulate',
		Color.black, Color.white,
		0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	$Tween.start()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _prev_page() -> void:
	set_process(false)
	_btn_left.rect_position.x = _dflt_left_x
	_btn_right.rect_position.x = _dflt_right_x
	_btn_left.hide()
	_btn_right.hide()
	_btn_exit.hide()
	_from_right = false
	
	$Tween.interpolate_property(
		_content, 'rect_position:x',
		_dflt_content_x, 380.0,
		0.3, Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$Tween.start()
	
	yield($Tween, 'tween_all_completed')
	
	self._current_page = max(_current_page - 1, 0)


func _next_page() -> void:
	set_process(false)
	_btn_left.rect_position.x = _dflt_left_x
	_btn_right.rect_position.x = _dflt_right_x
	_btn_left.hide()
	_btn_right.hide()
	_btn_exit.hide()
	_from_right = true
	
	$Tween.interpolate_property(
		_content, 'rect_position:x',
		_dflt_content_x, -180.0,
		0.3, Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$Tween.start()
	
	yield($Tween, 'tween_all_completed')
	
	self._current_page = min(_current_page + 1, _total_pages)


func _set_current_page(value: int) -> void:
	_current_page = value
	_pages_counter.text = '%d/%d' % [_current_page + 1, _total_pages + 1]
	_btn_left.disabled = true
	_btn_exit.hide()
	
	$Tween.interpolate_property(
		_content, 'rect_position:x',
		380.0 if _from_right else -180.0, _dflt_content_x,
		0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	$Tween.start()
	
	yield(get_tree(), 'idle_frame')
	_content.text = _current_document.pages[_current_page]
	
	A.play({
		cue_name = 'sfx_paper',
		is_in_queue = false
	})
	
	yield($Tween, 'tween_all_completed')
	
	_btn_left.show()
	_btn_right.show()
	
	if _current_page > 0:
		_btn_left.disabled = false
	
	if _current_page == _total_pages:
		_btn_right.hide()
		_btn_exit.show()
	
	set_process(true)


func _close() -> void:
	set_process(false)
	$Tween.remove_all()
	
	$Tween.interpolate_property(
		self, 'modulate:a',
		1.0, 0.0,
		0.4, Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, 'tween_all_completed')
	
	G.emit_signal('documents_closed', _current_document)
	hide()
	_current_document = {}
