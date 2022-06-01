extends CanvasLayer

var _offset = Vector2(4, 3)

var _playing = false
var _active = false
var _required_points = 0

const MAZE_PATH = 'res://popochiu/GraphicInterface/Popups/PC/MazeLevels/'

var _lives = 0

## levels
var mazes = ['001', '002', '003', '004']
var _completed_mazes = []
var _maze:Maze
var _maze_level

signal level_started
signal game_over
signal level_completed


func _ready():
	randomize()
	
	$Cursor.connect('validation_failed', self, '_on_fail')
	$Cursor.connect('goal_reached', self, '_on_success')
	$Cursor.connect('point_collected', self, '_on_point_collected')
	
	$Controls/up.connect('button_down', $Cursor, 'move_up')
	$Controls/down.connect('button_down', $Cursor, 'move_down')
	$Controls/left.connect('button_down', $Cursor, 'move_left')
	$Controls/right.connect('button_down', $Cursor, 'move_right')
	$Controls/start.connect('button_down', self, '_on_start')
	close_game()

func _input(event):
	if event.is_action_pressed('ui_left'):
		$Cursor.move_left()
	elif event.is_action_pressed('ui_right'):
		$Cursor.move_right()
	elif event.is_action_pressed('ui_up'):
		$Cursor.move_up()
	elif event.is_action_pressed('ui_down'):
		$Cursor.move_down()
	elif event.is_action_pressed('ui_accept'):
		_on_start()

func new_game(_lives, mazes):
	self._lives = _lives
	self.mazes = mazes
	self._active = true
	$OsOverlay.show()
	$Bg.show()
	$Controls.show()


func close_game():
	if _maze:
		remove_child(_maze)
		_maze.queue_free()
	self._active = false
	$OsOverlay.hide()
	$Bg.hide()
	$Controls.hide()
	$Start.hide()
	$Goal.hide()
	$Cursor.hide()

func _initialization():
	if _maze:
		remove_child(_maze)
		_maze.queue_free()
	var scene = load('%sMaze%s.tscn' % [MAZE_PATH, _maze_level])
	_maze = scene.instance()
	add_child(_maze)
	move_child(_maze, 2)
	$Cursor.tilemap = _maze
	var _start_location = _maze.get_used_cells_by_id(9)[0]
	_required_points = _maze.get_used_cells_by_id(15).size()
	
	$Start.position = _start_location * 6.0 + _offset
	$Controls/Status.text = 'press start'
	var _goal_location = _maze.get_used_cells_by_id(11)[0]
	$Goal.position = _goal_location * 6.0 + _offset
	$Start.show()
	$Goal.show()
	$Cursor.show()
	

func _on_start():
	if not self._active: return
	if mazes.size() == 0: return
	if not _maze_level:
		_maze_level = mazes[randi() % mazes.size()]
	self._initialization()
	$Cursor.start($Start.position)
	_playing = true
	$Controls/Status.text = 'playing'
	emit_signal('level_started')


func _on_fail():
	_playing = false
	$Controls/Status.text = 'fail - press start'
	_lives -= 1
	if _lives <= 0:
		emit_signal('game_over')


func _on_success():
	if _required_points == 0:
		_playing = false
		$Controls/Status.text = 'win - press start'
		mazes.remove(mazes.find(_maze_level))
		_completed_mazes.push_front(_maze_level)
		_maze_level = ''
		emit_signal('level_completed')
	else:
		$Controls/Status.text = 'pick the remaining points?'


func _on_point_collected():
	_set_required_points(_required_points - 1)
	$Controls/Status.text = 'point collected! %d remaining' % _required_points


func _set_required_points(_points):
	_required_points = _points
	if _points <= 0:
		print('make it visible?')

