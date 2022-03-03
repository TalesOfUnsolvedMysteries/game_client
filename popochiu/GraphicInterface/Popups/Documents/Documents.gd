extends PanelContainer
# Muestra documentos paginados al estilo de Resident Evil 2 y Resident Evil 3.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

var _current_page := 0 setget _set_current_page
var _current_document := {}
var _total_pages := 0

onready var _btn_left: TextureButton = find_node('BtnLeft')
onready var _type: TextureRect = find_node('Type')
onready var _btn_right: TextureButton = find_node('BtnRight')
onready var _btn_exit: Button = find_node('BtnExit')
onready var _pages_counter: Label = find_node('PagesCounter')
onready var _content: Label = find_node('Content')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	hide()
	
	# Conectarse a señales de los hijos
	_btn_left.connect('pressed', Utils, 'invoke', [self, '_prev_page'])
	_btn_right.connect('pressed', Utils, 'invoke', [self, '_next_page'])
	_btn_exit.connect('pressed', Utils, 'invoke', [self, '_close'])
	
	# Conectarse a señales de los singletones
	G.connect('documents_requested', self, 'show_documents')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_documents(data: Dictionary) -> void:
	# TODO: Usar el Tween para hacer un fade o algo.
	_current_document = data
	_total_pages = data.pages.size() - 1
	self._current_page = 0
	_type.texture = data.bg
	
	show()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _prev_page() -> void:
	self._current_page = max(_current_page - 1, 0)


func _next_page() -> void:
	self._current_page = min(_current_page + 1, _total_pages)


func _set_current_page(value: int) -> void:
	_current_page = value
	_content.text = _current_document.pages[_current_page]
	_pages_counter.text = '%d/%d' % [_current_page + 1, _total_pages + 1]
	_btn_left.disabled = false
	_btn_right.show()
	_btn_exit.hide()
	
	A.play({
		cue_name = 'sfx_paper',
		is_in_queue = false
	})
	
	if _current_page == 0:
		_btn_left.disabled = true
	elif _current_page == _total_pages:
		_btn_right.hide()
		_btn_exit.show()


func _close() -> void:
	hide()
