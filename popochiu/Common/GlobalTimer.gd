class_name GlobalTimer
extends Node

signal step_completed
signal timeout
signal started

export var step = 0.1
export var time_target = 1
var _acc = 0
var _step_acc = 0
var _playing = false

static func is_active(timer: String):
	return Globals.session_state.get('%s-active' % timer, false)

static func get_time(timer: String):
	return Globals.session_state.get('%s-time' % timer, 0.0)

func _ready():
	if get_parent() != Globals:
		load_global_timer()

func start():
	var _active = is_active(get_name())
	if _active: return false
	Globals.set_session_state('%s-active' % get_name(), true)
	var duplicated = self.duplicate()
	Globals.add_child(duplicated)
	duplicated._playing = true
	emit_signal('started')
	load_global_timer()
	return true


func stop():
	_playing = false
	emit_signal('timeout')
	Globals.set_session_state('%s-active' % get_name(), false)
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

func do_step():
	emit_signal('step_completed')
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'remote_step')
	
	if get_parent() == Globals:
		Globals.set_session_state('%s-time' % get_name(), _acc)
		yield(step_execution(), 'completed')

remote func remote_step():
	if NetworkManager.isPilot():
		emit_signal('step_completed')


func _process(delta):
	if !NetworkManager.server and !Globals.is_single_test(): return
	if _playing:
		_acc += delta
		_step_acc += delta
		if _acc >= time_target:
			return stop()
		if _step_acc >= step:
			_step_acc -= step
			do_step()

func timeout_execution():
	yield(get_tree(), 'idle_frame')

func step_execution():
	yield(get_tree(), 'idle_frame')

func load_global_timer():
	var _timer = Globals.find_node(self.name, true, false)
	if not _timer: return
	_timer.connect('step_completed', self, 'do_step')
	_timer.connect('timeout', self, 'stop')
