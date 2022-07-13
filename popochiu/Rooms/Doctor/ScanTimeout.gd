extends GlobalTimer

func timeout_execution():
	yield(get_tree(), 'idle_frame')
	print('on timeout globals')
	$RecoveryCooldown.start()

func step_execution():
	yield(get_tree(), 'idle_frame')
	var time = Globals.session_state.get('%s-time' % get_name(), 0)
	print('on time step globals: ', time)
	
