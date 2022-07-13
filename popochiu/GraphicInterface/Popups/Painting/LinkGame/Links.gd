extends Node2D
signal puzzle_loaded

var GamePoint = preload('res://popochiu/GraphicInterface/Popups/Painting/LinkGame/Point.tscn')
var map = []
var moves_enabled = 15
var original_moves = 6
var _locked = false
var _squared_radius = 16
var _playing = false
var _finished = false
var _current_point = null
var _points_path = []

var _puzzle_width = 0
var _puzzle_height = 0


func _ready():
	load_level('66enfndngnhkbngihnpnpnpndnonpnljompnlnonlnonpnpnllonpnlnonpnlnmnnnjamennjn')


func _reset():
	var _points = $Points.get_children()
	for point in _points:
		$Points.remove_child(point)
	_puzzle_width = 0
	_puzzle_height = 0


func add_point(point: LinkPoint):
	$Points.add_child(point)


func _get_nodes_for_edge(_position: Vector2):
	var _points = []
	for _point in $Points.get_children():
		if _position.distance_to(_point.position + $Points.position) < 15:
			_points.push_front(_point)
	return _points


func get_puzzle_width():
	return _puzzle_width

func get_puzzle_height():
	return _puzzle_height

func _on_starting_point_clicked(_point):
	if _finished: return
	if not _playing:
		$Path.points = PoolVector2Array([_point.position + $Points.position])
		self._link_point(_point)
		_playing = true


func _stop_playing():
	_playing = false
	$Path.points = PoolVector2Array([])
	for point in _points_path:
		point.set_entry_direction(0)
	_points_path = []
	_current_point = null


func _close_path():
	# should validate if the path is correct
	var total_totems = 0
	for _point in _points_path:
		if not _point.totem.empty(): total_totems += 1
	if total_totems != 7:
		self._stop_playing()
		return
	_playing = false
	_finished = true


func _link_point(_point):
	var _points = $Path.points
	_points[_points.size() - 1] = _point.position + $Points.position
	_points.append(_point.position + $Points.position)
	$Path.points = _points
	_current_point = _point
	original_moves = _point.original_moves
	_points_path.push_back(_point)


func _remove_last_point():
	var _points = $Path.points
	_points.remove(_points.size() - 1)
	var _removed = _points_path.pop_back()
	_points[_points.size() - 1] = get_local_mouse_position()
	$Path.points = _points
	_current_point = _points_path[-1]
	original_moves = _current_point.original_moves
	moves_enabled = LinkPoint.get_oposite(_removed._entry_direction)
	_removed.set_entry_direction(0)


func _process(delta):
	if not _playing: return
	var target = get_local_mouse_position()
	
	var last = $Path.points[$Path.points.size() - 1]
	var previous = $Path.points[$Path.points.size() - 2]
	
	var distance = target.distance_squared_to(previous)
	if distance > _squared_radius and not _locked:
		# should lock the movement
		var _angle = previous.angle_to_point(target) + PI
		if _angle >= PI/4 and _angle < 3*PI/4:
			moves_enabled = LinkPoint.DOWN
		elif _angle >= 3*PI/4 and _angle < 5*PI/4:
			moves_enabled = LinkPoint.LEFT
		elif _angle >= 5*PI/4 and _angle < 7*PI/4:
			moves_enabled = LinkPoint.UP
		else:
			moves_enabled = LinkPoint.RIGHT
		
		moves_enabled = moves_enabled & original_moves
		_locked = true
		
		# check not going back
		_on_point_exit(_current_point)
	elif distance < _squared_radius and _locked:
		_locked = false
		moves_enabled = 15
	# avoid off lines
	
	if distance > 13*13:
		target = previous + target.normalized()*13
		
	if (moves_enabled & LinkPoint.UP) == 0 and target.y < previous.y:
		target.y = previous.y
	if (moves_enabled & LinkPoint.RIGHT) == 0 and target.x > previous.x:
		target.x = previous.x
	if (moves_enabled & LinkPoint.DOWN) == 0 and target.y > previous.y:
		target.y = previous.y
	if (moves_enabled & LinkPoint.LEFT) == 0 and target.x < previous.x:
		target.x = previous.x
	
	$Path.points[$Path.points.size() - 1] = target


func _on_point_hover(_point):
	if not _playing: return
	if _points_path.has(_point): return
	var direction = _current_point.neighbour_direction(_point)
	if direction > 0:
		_point.set_entry_direction(direction)
		self._link_point(_point)
		if _point.is_start_point:
			self._close_path()


func _on_point_exit(_point):
	if not _playing: return
	if _current_point != _point: return
	if _current_point.is_start_point: return
	if _current_point._entry_direction == moves_enabled:
		self._remove_last_point()
	

func _input(event):
	if _playing and event is InputEventMouseButton and event.button_index == 2:
		self._stop_playing()


func load_level(_code):
	_reset()
	_puzzle_width = int(_code[0])
	_puzzle_height = int(_code[1])
	_code = _code.substr(2)
	var _size = _puzzle_width*_puzzle_height
	for i in _size:
		var _point = GamePoint.instance()
		var _coords = Vector2(i%_puzzle_width, floor(i/_puzzle_width))
		_point.coords = _coords
		_point.original_moves = ord(_code[i*2]) - 97
		_point.totem = ['0', '1', '2', '3', '4', '5', '6', '7', 'BEE', 'BEETLE', 'LADY_BUG', 'ROOSTER', 'TOTEM', ''][ord(_code[i*2 + 1]) - 97]
		if _point.is_start_point:
			_point.connect('clicked', self, '_on_starting_point_clicked')
		_point.connect('mouse_entered', self, '_on_point_hover')
		add_point(_point)
	print('puzzle loaded->')
	emit_signal('puzzle_loaded')
