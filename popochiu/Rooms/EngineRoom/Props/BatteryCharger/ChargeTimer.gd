extends GlobalTimer

func timeout_execution():
	yield(get_tree(), 'idle_frame')
	Globals.set_state('EngineRoom-MOTHERBOARD_BATTERY_FULL', true)
