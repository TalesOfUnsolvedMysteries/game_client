tool
extends Node2D
var GamePoint = preload('res://popochiu/GraphicInterface/Popups/Painting/LinkGame/Point.tscn')


onready var generate_btn = find_node('GenerateBtn')
onready var clear_btn = find_node('ClearBtn')
onready var puzzle_width = find_node('Width')
onready var puzzle_height = find_node('Height')
onready var totems = find_node('Totems')
onready var level = find_node('Level')
onready var load_btn = find_node('Load')

var _width: int = 0
var _height: int = 0

func _ready():
	clear_btn.connect('button_down', $Links, '_reset')
	generate_btn.connect('button_down', self, '_on_generate')
	load_btn.connect('button_down', self, '_on_load_clicked')
	_load_level('66gnhnhnhnhndnonpnpnpnpnlnonpnpnpnpnlnonpnpnpnpnlnonpnpnpnpnlnmnnnnnnnnnjn')


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		$Point.position = event.position + Vector2(-6, -27)
		var _points = $Links._get_nodes_for_edge($Point.position)
		$Point.position += $Links.position
		for point in _points:
			point.toggle_edge($Point.position)
		_encode_level()


func _on_generate():
	_width = puzzle_width.value
	_height = puzzle_height.value
	var _size = _width*_height
	$Links._reset()
	for i in _size:
		var _point = GamePoint.instance()
		var _coords = Vector2(i%_width, floor(i/_width))
		_point.coords = _coords
		if _coords.x == 0: _point.original_moves -= LinkPoint.LEFT
		if _coords.x == _width - 1: _point.original_moves -= LinkPoint.RIGHT
		if _coords.y == 0: _point.original_moves -= LinkPoint.UP
		if _coords.y == _height - 1: _point.original_moves -= LinkPoint.DOWN
		_point.connect('clicked', self, '_on_point_clicked')
		$Links.add_point(_point)
	_encode_level()

func _on_point_clicked(_point: LinkPoint):
	var key = totems.get_current_token()
	_point.set_totem(key)
	_encode_level()

func _encode_level():
	var code = ''
	code = '%d%d' % [_width, _height]
	for point in $Links.find_node('Points').get_children():
		var totem_index = ['0', '1', '2', '3', '4', '5', '6', '7', 'BEE', 'BEETLE', 'LADY_BUG', 'ROOSTER', 'TOTEM', ''].find(point.totem)
		code = '%s%s%s' % [code, char(point.original_moves + 97), char(totem_index + 97)]
	level.text = code

func _load_level(_code):
	_width = int(_code[0])
	_height = int(_code[1])
	_code = _code.substr(2)
	var _size = _width*_height
	$Links._reset()
	for i in _size:
		var _point = GamePoint.instance()
		var _coords = Vector2(i%_width, floor(i/_width))
		_point.coords = _coords
		_point.original_moves = ord(_code[i*2]) - 97
		_point.totem = ['0', '1', '2', '3', '4', '5', '6', '7', 'BEE', 'BEETLE', 'LADY_BUG', 'ROOSTER', 'TOTEM', ''][ord(_code[i*2 + 1]) - 97]
		_point.connect('clicked', self, '_on_point_clicked')
		$Links.add_point(_point)

func _on_load_clicked():
	# '66gnhnhnhnhndnonpfninnpklnonpnfnfnpnlmonpjhnhnpnlnonpnplpnpclnmnnnnnnnnnjn'
	_load_level(level.text)

