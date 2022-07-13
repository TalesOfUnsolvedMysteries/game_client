extends RemoteCall

func function_call(args:=[]):
	yield(get_tree(), 'idle_frame')
	randomize()
	var matched = args[0]
	var _kill_chance = 100 if matched else 50
	self.response = randi()%100 < _kill_chance
