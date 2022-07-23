extends Node2D

func print_full_data_dungeon(dungeon, decoration_data):
	print_dungeon(dungeon, decoration_data)
	var str_matrix = ''
	for j in dungeon['adjacency_matrix'].size():
		for i in dungeon['adjacency_matrix'][j].size():
			str_matrix += str(dungeon['adjacency_matrix'][j][i])
		str_matrix += '\n'

func decorate_dungeon_graph(dungeon: Dungeon) -> Dictionary:
	var rooms = dungeon.rooms
	var node_keys:Array = rooms.keys()
	node_keys.shuffle()
	var codes:String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	var index = 1.0
	var decorated_rooms = {}
	for key in node_keys:
		var room: DungeonRoom = dungeon.get_room(key)
		var code_key = codes[(int(index))%(codes.length())]
		var color_key = Color.from_hsv(index/node_keys.size(), 0.67, 0.9)
		decorated_rooms[key] = {
			'label': '[color=#%s]%s[/color]' % [color_key.to_html(false), code_key],
			'color': color_key,
			'code_key': code_key
		}
		index += 1.0
	return decorated_rooms

func print_dungeon(dungeon: Dungeon, decoration_data):
	var rooms = dungeon.rooms
	var basic_grid = []
	var node_keys:Array = rooms.keys()
	var width = dungeon.configuration._width
	var height = dungeon.configuration._height

	for j in range(0, height):
		basic_grid.push_back([])
		for i in range(0, width):
			basic_grid[j].push_back(' ')
	
	# {'key': key, 'squares': [base_square], 'edges': filtered_edges}
	for key in node_keys:
		var room = rooms[key]
		for square in room['squares']:
			for i in range(square[0], square[0] + square[2]):
				for j in range(square[1], square[1] + square[3]):
					basic_grid[j][i] = key
	
	var _dungeon_str = ''
	for j in range(0, height):
		for i in range(0, width):
			var key = basic_grid[j][i]
			_dungeon_str += decoration_data[key].label
		_dungeon_str += '\n'
	$RichTextLabel.bbcode_text = '[code]%s[/code]' % _dungeon_str
	draw_dungeon(dungeon, decoration_data)

func draw_dungeon(dungeon, decoration_data):
	for child in $Canvas.get_children():
		$Canvas.remove_child(child)
		child.queue_free()
	var cell_size = 7.0
	var rooms = dungeon.rooms
	var basic_grid = []
	var node_keys:Array = rooms.keys()
	# draw rooms
	for key in node_keys:
		var room: DungeonRoom = dungeon.get_room(key)
		var style = decoration_data[key]
		for square in room.squares:
			var poly := Polygon2D.new()
			poly.polygon = PoolVector2Array([
				Vector2(square[0], square[1])*cell_size,
				Vector2(square[0], square[1] + square[3])*cell_size,
				Vector2(square[0] + square[2], square[1] + square[3])*cell_size,
				Vector2(square[0] + square[2], square[1])*cell_size
			])
			poly.color = style.color
			$Canvas.add_child(poly)
	# draw doors
	for door_key in dungeon.doors.keys():
		var door: DungeonDoor = dungeon.doors.get(door_key)
		var poly := Polygon2D.new()
		var w = 0.2 if door.vertical else 0.6
		var h = 0.6 if door.vertical else 0.2
		var draw_door = door.position + (Vector2(0.4,0.15) if door.vertical else Vector2(0.15,0.4))
		poly.polygon = PoolVector2Array([
			Vector2(draw_door.x, draw_door.y)*cell_size,
			Vector2(draw_door.x, draw_door.y + h)*cell_size,
			Vector2(draw_door.x + w, draw_door.y + h)*cell_size,
			Vector2(draw_door.x + w, draw_door.y)*cell_size
		])
		poly.color = Color.white
		$Canvas.add_child(poly)
