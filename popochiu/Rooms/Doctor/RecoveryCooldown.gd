extends GlobalTimer

func timeout_execution():
	yield(get_tree(), 'idle_frame')
	print('recovered!')

func step_execution():
	yield(get_tree(), 'idle_frame')
	print('recovering')
