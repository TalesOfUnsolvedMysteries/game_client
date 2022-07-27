extends Node

func setup_level(dungeon: Dungeon, original_adjacency_matrix: Array):
	# locate leaves
	var room_keys = dungeon.rooms.keys()
	var root_key = dungeon.root_node
	var root_index = room_keys.find(root_key)
	var available_rooms = room_keys.duplicate()
	var special_rooms = []
	
	# load edges in rooms
	for j in room_keys.size():
		var edges = []
		for i in room_keys.size():
			if dungeon.adjacency_matrix[j][i] == 1: edges.push_back(room_keys[i])
		var room = dungeon.get_room(room_keys[j])
		room.edges = edges

	# get leaves
	var leaves: Array = DungeonUtils.get_leaves(dungeon.adjacency_matrix)
	var deep_matrix:Array = DungeonUtils.get_deep_matrix(dungeon.adjacency_matrix)
	# give each leaf a score based on distance
	var index = 0
	
	var farthest_node = -1
	var farthest_distance = -1
	for distance in deep_matrix[root_index]:
		if index == root_index: distance = 0
		var room = dungeon.get_room(room_keys[index])
		room.distance_to_root = distance
		if distance > farthest_distance:
			farthest_distance = distance
			farthest_node = index
		index += 1

	var farthest_nodes = [-1, -1, 0]
	for j in deep_matrix.size():
		for i in deep_matrix.size():
			var distance = deep_matrix[j][i]
			if distance > farthest_nodes[2]:
				farthest_nodes[0] = room_keys[j]
				farthest_nodes[1] = room_keys[i]
				farthest_nodes[2] = distance
	print('farthest distance between %d and %d is %d' % farthest_nodes)
	# get a path for all the possible nodes
	var paths = get_all_paths_for(root_index, dungeon.adjacency_matrix, deep_matrix)
	print('leaves size: %d' % leaves.size())
	print('paths size: %d' % paths.size())
	print('farthest distance %d' % farthest_distance)
	
	# setup start
	mark_cell_as_used(available_rooms, leaves, room_keys, root_key)
	

	# place exit in one of the farthest
	if dungeon.configuration._exit > 0:
		var exit = dungeon.get_room(room_keys[farthest_node])
		exit.type = [DungeonRoom.Types.EXIT, DungeonRoom.Types.END][dungeon.configuration._exit - 1]
		available_rooms.erase(exit.key)
		leaves.erase(farthest_node)
		mark_cell_as_used(available_rooms, leaves, room_keys,  exit.key)
		special_rooms.push_back(exit.key)
	
	# BOSS
	# an obstacle to the exit, only on a path room (exactly 2 doors) second door is locked and boss has the key
	# next room to this is a loot room
	# get path for boss:
	if dungeon.configuration._boss_code.length() > 0:
		var path_to_boss = []
		for path in paths:
			if path[-1] == farthest_node:
				path_to_boss = path.duplicate()
				break
		if path_to_boss.size() < 4: print('ERROR!!!')
		var boss_room_key = room_keys[path_to_boss[-3]]
		var loot_room_key = room_keys[path_to_boss[-2]]
		var boss_code = dungeon.configuration._boss_code
		var boss_room := dungeon.get_room(boss_room_key)
		boss_room.type = DungeonRoom.Types.BOSS
		boss_room.set_contents([{'type': 'boss', 'loot': ['boss_key_%s' % boss_code], 'code': boss_code}])
		mark_cell_as_used(available_rooms, leaves, room_keys, boss_room_key)
		# lock door
		var door = dungeon.doors[DungeonDoor.get_key_for(boss_room_key, loot_room_key)]
		door.lock_with_key('boss_key_%s' % boss_code)
	# LOOT ROOM
	# exclusive room after boss containing an special ITEM
		var loot_room := dungeon.get_room(loot_room_key)
		loot_room.type = DungeonRoom.Types.LOOT
		loot_room.set_contents(dungeon.configuration._loot_contents)
		mark_cell_as_used(available_rooms, leaves, room_keys, loot_room_key)
		# remove exit as it has a blocker with the boss
		print(special_rooms)
		print('special_rooms remove ', room_keys[farthest_node])
		special_rooms.erase(room_keys[farthest_node])
		# but place boss room
		special_rooms.push_back(boss_room_key)
		print(special_rooms)
	
	# SPECIAL ITEM ROOM 
	for special_item in dungeon.configuration._special_items:
		# choose a random available leave
		var room_key = get_next_available_leaf(leaves, deep_matrix, available_rooms, room_keys, root_index)
		var special_item_room := dungeon.get_room(room_key)
		special_item_room.type = DungeonRoom.Types.SPECIAL_ITEM
		special_item_room.set_contents([{'type': 'special_item', 'code': special_item}])
		mark_cell_as_used(available_rooms, leaves, room_keys, room_key)
		special_rooms.push_back(room_key)
	
	# TERMINAL
	# should be in a leaf room behind a dark room, a lock or a great number of enemies
	if dungeon.configuration._terminal_code:
		var room_key = get_next_available_leaf(leaves, deep_matrix, available_rooms, room_keys, root_index)
		var terminal_room := dungeon.get_room(room_key)
		terminal_room.type = DungeonRoom.Types.TERMINAL
		terminal_room.set_contents([{'type': 'terminal', 'code': dungeon.configuration._terminal_code}])
		mark_cell_as_used(available_rooms, leaves, room_keys, room_key)
		special_rooms.push_back(room_key)
	
	# SAFE ROOM
	for i in dungeon.configuration._safe_rooms:
		var room_key = get_next_available_leaf(leaves, deep_matrix, available_rooms, room_keys, root_index)
		var safe_room := dungeon.get_room(room_key)
		safe_room.type = DungeonRoom.Types.SAFE
		mark_cell_as_used(available_rooms, leaves, room_keys, room_key)
		special_rooms.push_back(room_key)
	
	# SURVIVOR ROOM
	if dungeon.configuration._survivor_code.length() > 0:
		var room_key = get_next_available_leaf(leaves, deep_matrix, available_rooms, room_keys, root_index)
		var survivor_room := dungeon.get_room(room_key)
		survivor_room.type = DungeonRoom.Types.SURVIVOR
		survivor_room.set_contents([{'type': 'survivor', 'code': dungeon.configuration._survivor_code}])
		mark_cell_as_used(available_rooms, leaves, room_keys, room_key)
		special_rooms.push_back(room_key)
	
	# Locked rooms or locked paths...
	# check only one for now...
	var lock_candidates = special_rooms.duplicate()
	for i in dungeon.configuration._locked_rooms:
		# choose a random room
		var room_key = lock_candidates[randi()%lock_candidates.size()]
		var room_index = room_keys.find(room_key)
		lock_candidates.erase(room_key)
		var path_to_room = []
		paths.shuffle()
		for path in paths:
			if path.find(room_index) != -1:
				path_to_room = path.duplicate()
				break
		
		var room_for_key = -1
		var door_to_lock = ''
		while room_for_key == -1:
			var index_in_path = clamp(randi()%(path_to_room.size()-1), path_to_room.size() - 5, path_to_room.size() - 2)
			var door_lock = path_to_room[index_in_path]
			# get all the paths for available leaves
			var paths_to_key = get_paths(paths, leaves, [door_lock])
			if paths_to_key.size() == 0: continue
			# check the largest paths that don't contain door_pos
			var largest = get_largest_path(paths_to_key)
			# place a key there
			room_for_key = room_keys[largest[-1]]
			door_to_lock = DungeonDoor.get_key_for(room_keys[path_to_room[index_in_path + 1]], room_keys[door_lock])
		
		var room_with_key = dungeon.get_room(room_for_key)
		room_with_key.type = DungeonRoom.Types.KEY
		room_with_key.set_contents([{'type': 'key', 'code': 'key-%s' % door_to_lock}])
		mark_cell_as_used(available_rooms, leaves, room_keys, room_with_key)
		# lock door
		var door = dungeon.doors[door_to_lock]
		door.lock_with_key('key-%s' % door_to_lock)

	# DARK ROOM
	# given a leave go backwards and check what is the most closest bifurcation room (a room with more than 2 doors enabled)
	# locate the dark room there, leaves affected by that path can't contain an exit or a key to an exit (unless it is explicitly set on dungeon config)
	# dark room hide leaves according to the type...
	var dark_room_candidates = special_rooms.duplicate()
	for dark_room in dungeon.configuration._dark_rooms:
		var room_key = get_room_by_type(dungeon, dark_room, dark_room_candidates)
		if room_key == -1: break
		var room_index = room_keys.find(room_key)
		dark_room_candidates.erase(room_key)
		var path_to_room = []
		for path in paths:
			if path[-1] == room_index:
				path_to_room = path
				break
		var dark_room_key = room_keys[path_to_room[-2]]
		var room = dungeon.get_room(dark_room_key)
		dark_room_candidates.push_back(dark_room_key)
		if room.type != DungeonRoom.Types.BASIC:
			continue
		room.type = DungeonRoom.Types.DARK
		for i in randi()%4:
			room.add_enemy('basic')
		special_rooms.push_back(dark_room_key)
		
	# SIDE LOCKS
	# check for a room with a high distance, if there is any adjacent room (with no door) with a shorter distance
	# at least -2 distance to root, a side lock could be placed from greater distance room to shorter
	# 
	# given a leave check all disabled doors
	# which one connects to a shorter path than current value?
	# create a side lock door in that path
	# that leaf is a good candidate for a safe room or terminal room


	# REGULAR ITEMs
	
	
	# ENEMIES

	
	
	pass

func get_room_by_type(dungeon, dark_room_type, candidates):
	for candidate in candidates:
		var room = dungeon.get_room(candidate)
		if room.type == dark_room_type:
			return candidate
	return -1

func get_paths(paths, must_have, must_exclude):
	var _paths = []
	for path in paths:
		var excluded = false
		for index in must_have:
			excluded = true
			if path.has(index):
				excluded = false
				break
		for index in must_exclude:
			if path.has(index):
				excluded = true
				break
		if not excluded:
			_paths.push_back(path.duplicate())
	return _paths

func get_largest_path(paths):
	var largest_path = -1
	var _path = []
	for path in paths:
		if path.size() > largest_path:
			_path = path
			largest_path = path.size()
	return _path.duplicate()

func mark_cell_as_used(available_rooms, leaves, room_keys, room_key):
	var cell_index = room_keys.find(room_key)
	available_rooms.erase(room_key)
	leaves.erase(cell_index)

func get_next_available_leaf(leaves, deep_matrix, available_rooms, room_keys, root_index):
	var cell_key = -1
	if leaves.size() > 0:
		leaves.shuffle()
		# find farthest available leave
		var max_distance = -1
		for leaf_index in leaves:
			var distance = deep_matrix[root_index][leaf_index]
			if distance > max_distance:
				cell_key = room_keys[leaf_index]
				max_distance = distance
	else: # choose a random cell available cell
		cell_key = available_rooms[randi() % available_rooms.size()]
	return cell_key

func get_all_paths_for(index, adjacency_matrix, deep_matrix):
	var paths = [[index]]
	var deep = 1
	var max_deep = 0
	for i in deep_matrix.size():
		if deep_matrix[index][i] > max_deep:
			max_deep = deep_matrix[index][i]
			deep_matrix[index][index] = 0
	
	var definitive_paths = []
	while deep <= max_deep:
		var _paths = []
		var pushed_paths = []
		for i in adjacency_matrix.size():
			if deep_matrix[index][i] == deep:
				for path in paths:
					var new_path = path.duplicate()
					if adjacency_matrix[path[-1]][i] == 1 and deep_matrix[index][path[-1]] == deep - 1:
						new_path.push_back(i)
						_paths.push_back(new_path)
		for path in paths:
			if path.size() == deep:
				definitive_paths.push_back(path)
		paths = _paths
		deep += 1
	for path in paths:
		if path.size() == deep:
			definitive_paths.push_back(path)
	return definitive_paths

func test():
	#var leaves = get_leaves(result_matrix)
	#for index in leaves:
	#	var key = keys[index]
	#	var room := dungeon.get_room(key)
	#	if room.type == DungeonRoom.Types.BASIC:
	#		room.type = DungeonRoom.Types.LEAF
	pass


