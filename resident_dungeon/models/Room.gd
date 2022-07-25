extends Resource


class_name DungeonRoom

enum Types { BASIC, ROOT }

var key: int
var squares: Array # array of Rect2
var polygon: PoolVector2Array
var edges: Array
var type = Types.BASIC

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
	var merge = Geometry.merge_polygons_2d(polygon, room.polygon)
	if merge.size() > 0:
		print(merge)
	polygon = PoolVector2Array(merge[0])
