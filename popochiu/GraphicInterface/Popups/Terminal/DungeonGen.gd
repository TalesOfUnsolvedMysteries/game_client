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

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	$Control/Generate.connect('button_down', self, 'generate')
	$Control/Generate2.connect('button_down', self, 'generate2')


func generate():
	seed(_seed)

	# build basic grid
	var basic_grid = []
	var index = 0
	for j in range(0, _height):
		for i in range(0, _width):
			# index, i, j, edge_indexes, width, height, child_rooms
			var room_node = [index, i, j, [], 1, 1,[]]
			if j != 0: room_node[3].push_back(index - _width)
			if i != 0: room_node[3].push_back(index - 1)
			if i != _width - 1: room_node[3].push_back(index + 1)
			if j != _height - 1: room_node[3].push_back(index + _width)
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
		cell[3] = filtered_edges
		room_graph[cell[0]] = cell
	print_dungeon(room_graph)
	return room_graph

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
	for key in node_keys:
		code_keys[key] = codes[index%(codes.length())]
		var cell = room_graph[key]
		for i in range(cell[1], cell[1] + cell[4]):
			for j in range(cell[2], cell[2] + cell[5]):
				basic_grid[j][i] = cell[0]
		index += 1
	
	
	for child_button in buttons.get_children():
		buttons.remove_child(child_button)
	
	for key in node_keys:
		var cell = room_graph[key]
		if cell[0] != int(key): continue
		var _btn = Button.new()
		_btn.text = code_keys[key]
		_btn.connect("button_down", self, '_load_node', [room_graph, key])
		buttons.add_child(_btn)
	
	# colored dungeon
	var total = buttons.get_child_count()
	index = 0
	var colors = {}
	for key in node_keys:
		var cell = room_graph[key]
		if cell[0] != int(key): continue
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


func _load_node(room_graph, key):
	$Control/RichTextLabel.text = str(room_graph[key])

func set_seed(__seed):
	_seed = __seed
	if buttons: generate()




