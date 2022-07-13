class_name GlobalTimer
extends Node

signal step_completed(elapsed_time)
signal timeout
signal started

export var step = 0.1
export var time_target = 1
export var global_state = false
var _elapsed_time = 0
var _step_acc = 0
var _playing = false

static func is_active(timer: String):
	return Globals.session_state.get('%s-active' % timer, false) or Globals.state.get('%s-active' % timer, false)

static func get_time(timer: String):
	var key = '%s-time' % timer
	if Globals.session_state.has(key):
		return Globals.session_state.get(key, 0)
	if Globals.state.has(key):
		return Globals.state.get(key, 0)
	return 0

func set_active(value):
	var key = '%s-active' % get_name()
	if global_state:
		Globals.set_state(key, value)
	else:
		Globals.set_session_state(key, value)

func save_time_state():
	var key = '%s-time' % get_name()
	if global_state:
		Globals.set_state(key, _elapsed_time)
	else:
		Globals.set_session_state(key, _elapsed_time)

func _ready():
	if get_parent() != Globals:
		load_global_timer()

func start():
	var _active = is_active(get_name())
	if _active: return false
	set_active(true)
	var duplicated = self.duplicate()
	Globals.add_child(duplicated)
	duplicated._playing = true
	emit_signal('started')
	load_global_timer()
	return true

func _reset():
	_playing = false
	_elapsed_time = 0
	_step_acc = 0

func stop():
	_reset()
	emit_signal('timeout')
	set_active(false)
	save_time_state()
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'remote_stop')
	
	if get_parent() == Globals:
		yield(timeout_execution(), 'completed')
		queue_free()


remote func remote_stop():
	if NetworkManager.isPilot():
		emit_signal('timeout')
		if get_parent() == Globals:
			queue_free()

func do_step(elapsed_time):
	emit_signal('step_completed', elapsed_time)
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'remote_step', elapsed_time)
	
	if get_parent() == Globals:
		save_time_state()
		yield(step_execution(), 'completed')

remote func remote_step(elapsed_time):
	if NetworkManager.isPilot():
		emit_signal('step_completed', elapsed_time)


func _process(delta):
	if !NetworkManager.server and !Globals.is_single_test(): return
	if _playing:
		_elapsed_time += delta
		_step_acc += delta
		if _step_acc >= step:
			_step_acc -= step
			do_step(_elapsed_time)
		if _elapsed_time >= time_target:
			stop()

func timeout_execution():
	yield(get_tree(), 'idle_frame')

func step_execution():
	yield(get_tree(), 'idle_frame')

func load_global_timer():
	var _timer = Globals.find_node(self.name, true, false)
	if not _timer: return
	_timer.connect('step_completed', self, 'do_step')
	_timer.connect('timeout', self, 'stop')
