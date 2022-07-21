extends Node2D

export(int) var _width = 16 # to_export
export(int) var _height = 8 # to_export
export(int) var _seed = 1 setget set_seed

export(int) var _max_initial_room_width = 5 # to_export
export(int) var _max_initial_room_height = 4 # to_export
export(float) var _merge_grid_chance = 1.0 # to_export

export(float) var _select_room_chance = 0.6 # export
export(float) var _merge_room_chance = 0.4 # export
export(bool) var _merge_parent_rooms = true # export
export(bool) var _merge_child_rooms = true # export

onready var buttons = find_node('buttons')

var dungeon = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	$Control/Generate.connect('button_down', self, 'generate')
	$Control/Generate2.connect('button_down', self, 'generate2')
	$Control/Merge.connect('button_down', self, 'merge_step')


func generate():
	seed(_seed)

	# build basic grid
	var basic_grid := []
	var doors := {}
	var index = 0
	for j in range(0, _height):
		for i in range(0, _width):
			# index, i, j, edge_indexes, width, height, child_rooms
			var room_node = [index, i, j, [], 1, 1,[]]
			if j != 0:
				room_node[3].push_back(index - _width)
				add_door(doors, index, index - _width)
			if i != 0:
				room_node[3].push_back(index - 1)
				add_door(doors, index, index - 1)
			if i != _width - 1:
				room_node[3].push_back(index + 1)
				add_door(doors, index, index + 1)
			if j != _height - 1:
				room_node[3].push_back(index + _width)
				add_door(doors, index, index + _width)
			basic_grid.push_back(room_node)
			index += 1

	# generate squares
	var room_graph = {}
	for cell in basic_grid:
		if cell[3][0] == -1: continue	# already merged
		if randf() > _merge_grid_chance: continue
		var orientation = randf() > 0.5
		var _min_width = 1 if orientation else 2
		var _min_height = 1 if not orientation else 2
		# merge
		index = cell[0]
		var i = cell[1]
		var j = cell[2]
		var w = clamp(i + _min_width + (randi() % (_max_initial_room_width-_min_width)), i + _min_width, _width)
		var h = clamp(j + _min_height + (randi() % (_max_initial_room_height-_min_height)), j + _min_height, _height)

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
		
		for _i in range(i, w):
			for _j in range(j, h):
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
	
	print('total doors: ', doors.size())
	#print(doors)
	
	# a graph room:
	# room: key
	# 		squares: [[i, j, w, h]
	# adjacency matrix
	# doors
	
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
		room_graph[key] = {'key': key, 'squares': [base_square], 'edges': filtered_edges}
	var adjacency_matrix = get_adjacency_matrix_from(room_graph)
	dungeon = {
		'room_graph': room_graph,
		'adjacency_matrix': adjacency_matrix,
		'doors': doors
	}
	print_dungeon(room_graph)


func merge_rooms(key_a, key_b):
	var room_graph:Dictionary = dungeon['room_graph']
	var adjacency_matrix:Array = dungeon['adjacency_matrix']
	var doors:Dictionary = dungeon['doors']
	
	var keys: Array = room_graph.keys()
	var a_index = keys.find(key_a)
	var b_index = keys.find(key_b)
	for j in adjacency_matrix.size():
		var edge_key = keys[j]
		var existing_edge = adjacency_matrix[j][b_index]
		if existing_edge == 1:
			var door_a_edge_key = get_door_key(key_a, edge_key)
			var door_b_edge_key = get_door_key(key_b, edge_key)
			if adjacency_matrix[j][a_index] == 1:
				merge_doors(doors, door_a_edge_key, door_b_edge_key, true)
			else:
				doors[door_a_edge_key] = doors[door_b_edge_key]
				doors.erase(door_b_edge_key)
		
		adjacency_matrix[j][a_index] |= adjacency_matrix[j][b_index]
		adjacency_matrix[a_index][j] |= adjacency_matrix[b_index][j]
		adjacency_matrix[j][b_index] = 0
		adjacency_matrix[b_index][j] = 0
	adjacency_matrix[a_index][a_index] = 0
	# update room graph
	for j in adjacency_matrix.size():
		var node_key = keys[j]
		room_graph[node_key]['edges'] = []
		for i in adjacency_matrix[j].size():
			var edge_key = keys[i]
			if adjacency_matrix[j][i] == 1:
				room_graph[node_key]['edges'].push_back(edge_key)
		adjacency_matrix[j].remove(b_index)
	adjacency_matrix.remove(b_index)
	doors.erase(get_door_key(key_a, key_b))
	room_graph[key_a].squares.append_array(room_graph[key_b].squares)
	room_graph.erase(key_b)


func merge_step():
	var keys = dungeon['room_graph'].keys()
	var key = keys[randi()%keys.size()]
	var edges = dungeon['room_graph'][key]['edges']
	var edge = edges[randi()%edges.size()]
	print('merge %d with %d' % [key, edge])
	merge_rooms(key, edge)
	print_dungeon(dungeon['room_graph'])

func get_adjacency_matrix_from(room_graph: Dictionary):
	var keys = room_graph.keys()
	var matrix = []
	var index = 0
	for key in keys:
		matrix.push_back([])
		var edges:Array = room_graph[key]['edges']
		for _key in keys:
			matrix[index].push_back(1 if edges.has(_key) else 0)
		index += 1
	print(matrix)
	return matrix


func add_door(doors, a, b):
	var key = get_door_key(a, b)
	if doors.has(key): return
	var coords_a = Vector2(a%_width, floor(a/_width))
	var coords_b = Vector2(b%_width, floor(b/_width))
	doors[key] = coords_b*0.5 + coords_a*0.5

func get_door_key(a, b):
	if b < a:
		var t = a
		a = b
		b = t
	return '%d-%d' % [a, b]

func get_door(doors: Dictionary, a, b):
	var key = get_door_key(a, b)
	return doors.get(key)

func merge_doors(doors: Dictionary, key_a, key_b, merge_positions=true):
	var a_door = doors.get(key_a)
	var b_door = doors.get(key_b)
	if (not a_door) or (not b_door): return
	# random choice
	var pos = randf()
	var new_door = (a_door*pos + b_door*(1.0-pos))
	if not merge_positions:
		new_door = a_door if pos > 0.5 else b_door
	doors[key_a] = new_door
	doors.erase(key_b)

func get_index_for_room(basic_grid, index):
	var room = basic_grid[index]
	return room[3][1] if room[3][0] == -1 else index

func merge_room_doors(doors: Dictionary, basic_grid:Array, a, b, a_edges: Array, b_edges: Array):
	if a == 3:
		print('merge %d with %d' % [a, b])
		print(a_edges)
		print(b_edges)
	# door a-b must dissapear
	var merged_door_key = get_door_key(a, b)
	doors.has(merged_door_key) and doors.erase(merged_door_key)
	for b_edge in b_edges:
		# check real edge
		b_edge = get_index_for_room(basic_grid, b_edge)
		var a_bedge_key = get_door_key(a, b_edge)
		var b_bedge_key = get_door_key(b, b_edge)
		# for each door c in common for a and b:
		if a_edges.has(b_edge):
			# door a-c b-c must be merged into one of the two or an intersection
			merge_doors(doors, a_bedge_key, b_bedge_key)
		elif doors.has(b_bedge_key):
			# doors b-d and d not in a must be remaped as a-d
			doors[a_bedge_key] = doors[b_bedge_key]
			doors.erase(b_bedge_key)
	

func embed_nodes(room_graph, parent_index, child_index, check_parent=true):
	var parent = room_graph[parent_index]
	var child_room = room_graph[child_index]
	if check_parent and child_room[0] != child_index:
		embed_nodes(room_graph, parent_index, child_room[0])
	if child_room[6].size() > 0:
		for child in child_room[6]:
			embed_nodes(room_graph, parent_index, child, false) # reparent
		child_room[6] = []
	child_room[0] = parent[0]
	parent[3].erase(child_index)
	child_room[3].erase(parent[0])
	parent[6].push_back(child_index)

func generate2():
	var room_graph = generate()
	# step 3 merge nodes
	for key in room_graph.keys():
		var cell: Array = room_graph[key]
		if int(key) != cell[0]: continue
		if randf() > _select_room_chance: continue
		for _edge_index in cell[3]:
			if (not _merge_parent_rooms) and room_graph[_edge_index][6].size() > 0: continue
			if (not _merge_child_rooms) and room_graph[_edge_index][0] != _edge_index: continue
			if randf() > _merge_room_chance: continue
			embed_nodes(room_graph, cell[0], _edge_index)
	print_dungeon(room_graph)


func print_dungeon(room_graph):
	var _dungeon_str = ''
	var basic_grid = []
	var node_keys:Array = room_graph.keys()
	node_keys.shuffle()
	var codes:String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	var code_keys = {}
	for j in range(0, _height):
		basic_grid.push_back([])
		for i in range(0, _width):
			basic_grid[j].push_back(' ')
	
	var index = 0
	# {'key': key, 'squares': [base_square], 'edges': filtered_edges}
	for key in node_keys:
		code_keys[key] = codes[index%(codes.length())]
		var room = room_graph[key]
		for square in room['squares']:
			for i in range(square[0], square[0] + square[2]):
				for j in range(square[1], square[1] + square[3]):
					basic_grid[j][i] = room['key']
		index += 1
	
	
	for child_button in buttons.get_children():
		buttons.remove_child(child_button)
	
	for key in node_keys:
		var _btn = Button.new()
		_btn.text = code_keys[key]
		_btn.connect("button_down", self, '_load_node', [room_graph, key])
		buttons.add_child(_btn)
	
	# colored dungeon
	var total = buttons.get_child_count()
	index = 0
	var colors = {}
	for key in node_keys:
		var color = Color.from_hsv(index/total, 0.67, 0.9)
		index += 1.0
		colors[key] = color
	_dungeon_str = ''
	for j in range(0, _height):
		for i in range(0, _width):
			var key = basic_grid[j][i]
			_dungeon_str += '[color=#%s]%s[/color]' % [colors[key].to_html(false), code_keys[key]]
		_dungeon_str += '\n'
	$Control/RichTextLabel.bbcode_text = '[code]%s[/code]' % _dungeon_str


func _load_node(room_graph, key):
	$Control/RichTextLabel.text = str(room_graph[key])

func set_seed(__seed):
	_seed = __seed
	if buttons: generate()




