extends Resource


class_name DungeonRoom

enum Types { BASIC, START, LEAF, EXIT, END, BOSS, LOOT, TEST, SPECIAL_ITEM, TERMINAL, SAFE, SURVIVOR, KEY, DARK }

var key: int
var squares: Array # array of Rect2
var polygon: PoolVector2Array
var edges: Array
var type = Types.BASIC

# game specific
var distance_to_root = -1
var contents = []

func _init(_key, _squares, _edges):
	key = _key
	squares = _squares
	edges = _edges
	var square = squares[0]
	polygon = PoolVector2Array([
		Vector2(square.position.x, square.position.y),
		Vector2(square.end.x, square.position.y),
		Vector2(square.end.x, square.end.y),
		Vector2(square.position.x, square.end.y)
	])

func contains_point(point: Vector2):
	for square in squares:
		if square.has_point(point):
			return true
	return false

func merge_with_room(room: DungeonRoom):
	squares.append_array(room.squares)
	var prev = polygon
	var merge = Geometry.merge_polygons_2d(polygon, room.polygon)
	if merge.size() > 1:
		print(room.polygon)
		var exclude_area = Geometry.exclude_polygons_2d(PoolVector2Array(merge[0]), PoolVector2Array(merge[1]))
		#print(exclude_area)
		polygon = PoolVector2Array(exclude_area[0])
		type = Types.TEST
		return
	polygon = PoolVector2Array(merge[0])

func set_contents(things):
	contents = things.duplicate(true)
	
