extends Node2D
var PointGame = preload("res://popochiu/GraphicInterface/Popups/Painting/LinkGame/Point.gd")
var map = []
var moves_enabled = 15
var original_moves = 6
var _locked = false
var _squared_radius = 16
var _playing = false
var _finished = false
var _current_point = null
var _points_path = []


func _ready():
	for point in $Points.get_children():
		if point.is_start_point:
			point.connect('clicked', self, '_on_starting_point_clicked')
		point.connect('mouse_entered', self, '_on_point_hover')

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
	print(_points)
	_points[_points.size() - 1] = get_global_mouse_position()
	print(_points)
	$Path.points = _points
	_current_point = _points_path[-1]
	original_moves = _current_point.original_moves
	moves_enabled = PointGame.get_oposite(_removed._entry_direction)
	_removed.set_entry_direction(0)

func _process(delta):
	if not _playing: return
	var target = get_global_mouse_position()
	var last = $Path.points[$Path.points.size() - 1]
	var previous = $Path.points[$Path.points.size() - 2]
	
	var distance = target.distance_squared_to(previous)
	if distance > _squared_radius and not _locked:
		# should lock the movement
		var _angle = previous.angle_to_point(target) + PI
		if _angle >= PI/4 and _angle < 3*PI/4:
			moves_enabled = PointGame.DOWN
		elif _angle >= 3*PI/4 and _angle < 5*PI/4:
			moves_enabled = PointGame.LEFT
		elif _angle >= 5*PI/4 and _angle < 7*PI/4:
			moves_enabled = PointGame.UP
		else:
			moves_enabled = PointGame.RIGHT
		
		moves_enabled = moves_enabled & original_moves
		_locked = true
		
		# check not going back
		_on_point_exit(_current_point)
	elif distance < _squared_radius and _locked:
		_locked = false
		moves_enabled = 15
	# avoid off lines
	if distance > 121:
		target = previous + target.normalized()*11
		
	if (moves_enabled & PointGame.UP) == 0 and target.y < previous.y:
		target.y = previous.y
	if (moves_enabled & PointGame.RIGHT) == 0 and target.x > previous.x:
		target.x = previous.x
	if (moves_enabled & PointGame.DOWN) == 0 and target.y > previous.y:
		target.y = previous.y
	if (moves_enabled & PointGame.LEFT) == 0 and target.x < previous.x:
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

