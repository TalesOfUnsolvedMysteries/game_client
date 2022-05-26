extends CanvasLayer

var _offset = Vector2(4, 3)

var _playing = false
var _required_points = 0

func _ready():
	$Cursor.tilemap = $TileMap
	$Cursor.connect('validation_failed', self, '_on_fail')
	$Cursor.connect('goal_reached', self, '_on_success')
	$Cursor.connect('point_collected', self, '_on_point_collected')
	
	$Controls/up.connect('button_down', $Cursor, 'move_up')
	$Controls/down.connect('button_down', $Cursor, 'move_down')
	$Controls/left.connect('button_down', $Cursor, 'move_left')
	$Controls/right.connect('button_down', $Cursor, 'move_right')
	$Controls/start.connect('button_down', self, '_on_start')
	self._initialization()

func _initialization():
	var _start_location = $TileMap.get_used_cells_by_id(9)[0]
	
	_required_points = $TileMap.get_used_cells_by_id(15).size()
	
	$Start.position = _start_location * 6.0 + _offset
	$Controls/Status.text = 'press start'
	var _goal_location = $TileMap.get_used_cells_by_id(11)[0]
	$Goal.position = _goal_location * 6.0 + _offset
	
func _on_start():
	$Cursor.start($Start.position)
	_playing = true
	$Controls/Status.text = 'playing'

func _on_fail():
	_playing = false
	$Controls/Status.text = 'fail - press start'

func _on_success():
	if _required_points == 0:
		_playing = false
		$Controls/Status.text = 'win - press start'
	else:
		$Controls/Status.text = 'pick the remaining points?'

func _on_point_collected():
	_set_required_points(_required_points - 1)
	$Controls/Status.text = 'point collected! %d remaining' % _required_points

func _set_required_points(_points):
	_required_points = _points
	if _points <= 0:
		print('make it visible?')
