extends Node

func setup_level(dungeon: Dungeon, original_adjacency_matrix: Array):
	# locate leaves
	var room_keys = dungeon.rooms.keys()
	var root_key = dungeon.root_node
	
	# load edges in rooms
	for j in room_keys.size():
		var edges = []
		for i in room_keys.size():
			if dungeon.adjacency_matrix[j][i] == 1: edges.push_back(room_keys[i])
		var room:DungeonRoom = dungeon.get_room(room_keys[j])
		room.edges = edges
	
	# get leaves
	var leaves: Array = DungeonUtils.get_leaves(dungeon.adjacency_matrix)
	var deep_matrix: Array = DungeonUtils.get_deep_matrix(dungeon.adjacency_matrix)
	# give each leaf a score based on distance
	var index = 0
	var root_index = room_keys.find(root_key)
	var farthest_node = -1
	var farthest_distance = -1
	for distance in deep_matrix[root_index]:
		if index == root_index: distance = 0
		var room:DungeonRoom = dungeon.get_room(room_keys[index])
		room.distance_to_root = distance
		if distance > farthest_distance:
			farthest_distance = distance
			farthest_node = index
		index += 1
	
	# get a path for all the possible leaves
	var paths = get_path_for(dungeon, root_key, -1)
	for path in paths:
		print(path)

	
	# place exit in one of the farthest
	var exit:DungeonRoom = dungeon.get_room(room_keys[farthest_node])
	exit.type = DungeonRoom.Types.EXIT
	
	# SIDE LOCKS
	# given a leave check all disabled doors
	# which one connects to a shorter path than current value?
	# create a side lock door in that path
	# that leaf is a good candidate for a safe room or terminal room
	
	# KEY LOCKED DOORS - KEYS and LOCKED DOORS
	# a key works like an extension of a path
	# given these paths: ROOT -> A -> B -> C -> D -> E -> F
	# and ROOT -> Z -> Y -> X -> W
	# a good place to place a keyhole would be Y and the key at the end of F
	# that will transform the second path into:
	# ROOT -> A -> B -> C -> D -> E -> F -> Y -> X -> W
	# so a good candidate for KEY LOCKED DOORS are shorter paths and keys in longer paths
	
	# DARK ROOM
	# given a leave go backwards and check what is the most closest bifurcation room (a room with more than 2 doors enabled)
	# locate the dark room there, leaves affected by that path can't contain an exit or a key to an exit (unless it is explicitly set on dungeon config)
	
	# TERMINAL
	# should be in a leaf room behind a dark room, a lock or a great number of enemies
	
	# SAFE ROOM
	
	# SPECIAL ITEM ROOM
	
	# REGULAR ITEMs
	
	# SURVIVOR ROOM
	
	# ENEMIES
	
	# BOSS
	# an obstacle to the exit, only on a path room (exactly 2 doors) second door is locked and boss has the key
	# next room to this is a loot room
	
	# LOOT ROOM
	# exclusive room after boss containing an special ITEM
	
	
	pass

func get_path_for(dungeon: Dungeon, room_id: int, parent_key: int):
	var room: DungeonRoom = dungeon.get_room(room_id)
	var edges = room.edges.duplicate(true)
	edges.erase(parent_key)
	if edges.size() == 0: return [[room_id]]
	var paths = []
	for key in edges:
		var _deep_paths = get_path_for(dungeon, key, room_id)
		for path in _deep_paths:
			path.push_front(room_id)
			paths.push_back(path)
	return paths
	

func test():
	#var leaves = get_leaves(result_matrix)
	#for index in leaves:
	#	var key = keys[index]
	#	var room := dungeon.get_room(key)
	#	if room.type == DungeonRoom.Types.BASIC:
	#		room.type = DungeonRoom.Types.LEAF
	pass


