extends Node

func generate(dungeon_config: DungeonResource) -> Dungeon:
	var basic_grid := []
	seed(dungeon_config._seed)
	# build basic grid
	var doors := {}
	var index = 0
	var _width = dungeon_config._width
	var _height = dungeon_config._height
	var _max_initial_room_width = dungeon_config._max_initial_room_width
	var _max_initial_room_height = dungeon_config._max_initial_room_height
	
	for j in range(0, _height):
		for i in range(0, _width):
			# index, i, j, edge_indexes, width, height, child_rooms
			var room_node = [index, i, j, [], 1, 1,[]]
			if j != 0:
				room_node[3].push_back(index - _width)
				add_door(doors, index, index - _width, 0, _width)
			if i != 0:
				room_node[3].push_back(index - 1)
				add_door(doors, index, index - 1, 1, _width)
			if i != _width - 1:
				room_node[3].push_back(index + 1)
				add_door(doors, index, index + 1, 1, _width)
			if j != _height - 1:
				room_node[3].push_back(index + _width)
				add_door(doors, index, index + _width, 0, _width)
			basic_grid.push_back(room_node)
			index += 1

	# generate squares
	var rooms = {}
	for cell in basic_grid:
		if cell[3][0] == -1: continue	# already merged
		if randf() > dungeon_config._merge_grid_chance: continue
		var orientation = randf() > 0.5
		var _min_width = 1 if orientation else 2
		var _min_height = 1 if not orientation else 2
		# merge
		index = cell[0]
		var i = cell[1]
		var j = cell[2]
		var _max_width = clamp(_max_initial_room_width - _min_width, 1, _max_initial_room_width)
		var _max_height = clamp(_max_initial_room_height - _min_height, 1, _max_initial_room_height)
		var w = clamp(i + _min_width + (randi() % _max_width), i + _min_width, _width)
		var h = clamp(j + _min_height + (randi() % _max_height), j + _min_height, _height)

		for _j in range(j, h):
			for _i in range(i, w):
				var _merge_index = (_j * _width) + _i
				var _to_merge = basic_grid[_merge_index]
				if _to_merge[3][0] == -1:
					if _i <= w:
						w = _i
					break
				
		cell[4] = w - i
		cell[5] = h - j
		
		for _j in range(j, h):
			for _i in range(i, w):
				var _merge_index = (_j * _width) + _i
				if _merge_index == index: continue
				var _to_merge = basic_grid[_merge_index]
				if _to_merge[3][0] == -1: continue
				# merge with next cells
				merge_room_doors(doors, basic_grid, index, _merge_index, cell[3], _to_merge[3])
				cell[3].erase(_merge_index)	# remove conection to that cell
				_to_merge[3].erase(index)	# remove conection in cell to merge
				cell[3].append_array(_to_merge[3])
				_to_merge[3] = [-1, index]
	
	# refine map, transform into graph
	for cell in basic_grid:
		if cell[3][0] == -1: continue	# already merged
		var filtered_edges: Array = []
		for _edge_index in cell[3]:
			var _edge_cell = basic_grid[_edge_index]
			while _edge_cell[3][0] == -1:
				_edge_index = _edge_cell[3][1]
				_edge_cell = basic_grid[_edge_index]
			if not filtered_edges.has(_edge_index) and _edge_index != cell[0]:
				filtered_edges.push_back(_edge_index)
		var key = cell[0]
		var base_square = [cell[1], cell[2], cell[4], cell[5]]
		rooms[key] = DungeonRoom.new(key, [base_square], filtered_edges)
	
	var dungeon = Dungeon.new()
	dungeon.configuration = dungeon_config
	dungeon.rooms = rooms
	dungeon.doors = doors
	dungeon.adjacency_matrix = get_adjacency_matrix_from(rooms)
	return dungeon


func get_adjacency_matrix_from(rooms: Dictionary):
	var keys = rooms.keys()
	var matrix := []
	var index = 0
	for key in keys:
		matrix.push_back([])
		var edges:Array = rooms[key]['edges']
		for _key in keys:
			matrix[index].push_back(1 if edges.has(_key) else 0)
		index += 1
	return matrix


func add_door(doors, a, b, vertical, _width):
	var key = DungeonDoor.get_key_for(a, b)
	if doors.has(key): return
	var coords_a = Vector3(a%_width, floor(a/_width), vertical)
	var coords_b = Vector3(b%_width, floor(b/_width), vertical)
	doors[key] = coords_b*0.5 + coords_a*0.5


func merge_room_doors(doors: Dictionary, basic_grid:Array, a, b, a_edges: Array, b_edges: Array):
	# door a-b must dissapear
	var merged_door_key = Dungeon.get_key_for(a, b)
	doors.has(merged_door_key) and doors.erase(merged_door_key)

	var index = 0
	for a_edge in a_edges:
		a_edges[index] = get_index_for_room(basic_grid, a_edge)
		index+=1
	index = 0
	for b_edge in b_edges:
		b_edges[index] = get_index_for_room(basic_grid, b_edge)
		index+=1
	
	for b_edge in b_edges:
		# check real edge
		#b_edge = get_index_for_room(basic_grid, b_edge)
		var a_bedge_key = Dungeon.get_key_for(a, b_edge)
		var b_bedge_key = Dungeon.get_key_for(b, b_edge)
		# for each door c in common for a and b:
		if a == b_edge: continue
		if a_edges.has(b_edge):
			# door a-c b-c must be merged into one of the two or an intersection
			DungeonUtils.merge_doors(doors, a_bedge_key, b_bedge_key)
		elif doors.has(b_bedge_key):
			# doors b-d and d not in a must be remaped as a-d
			doors[a_bedge_key] = doors[b_bedge_key]
			doors.erase(b_bedge_key)


func get_index_for_room(basic_grid, index):
	var room = basic_grid[index]
	return room[3][1] if room[3][0] == -1 else index

