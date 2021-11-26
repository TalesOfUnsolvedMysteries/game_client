extends Node2D
const Block = preload("res://popochiu/GraphicInterface/Puzzles/Block.tscn")

var config = [
	{ 'tile': [1, 1], 'size': [1, 1], 'target': [2, 0], 'label': '3', 'lock_on_match': false},
	{ 'tile': [2, 0], 'size': [1, 1], 'target': [1, 1], 'label': '5', 'lock_on_match': false},
	{ 'tile': [0, 1], 'size': [1, 1], 'target': [0, 2], 'label': '7', 'lock_on_match': false},
	{ 'tile': [0, 0], 'size': [1, 1], 'target': [0, 0], 'label': '1', 'lock_on_match': false},
	{ 'tile': [1, 0], 'size': [1, 1], 'target': [2, 1], 'label': '6', 'lock_on_match': false},
	{ 'tile': [2, 1], 'size': [1, 1], 'target': [1, 2], 'label': '8', 'lock_on_match': false},
	{ 'tile': [2, 2], 'size': [1, 1], 'target': [1, 0], 'label': '2', 'lock_on_match': false},
	{ 'tile': [1, 2], 'size': [1, 1], 'target': [0, 1], 'label': '4', 'lock_on_match': false}
]

var grid = [
	[0,0,0],
	[0,0,0],
	[0,0,0]
]

var offset = Vector2(0, 0)
var targets_to_reach = 0

func _ready():
	var idx = 0
	offset.x = grid[0].size()*-10 + 10
	offset.y = grid.size()*-10 + 10
	print(offset)
	targets_to_reach = 0
	for block_config in config:
		var block = Block.instance()
		block.offset = offset
		block.connect('drag_started', self, 'pick_block')
		block.connect('drag_ended', self, 'update_grid')
		block.connect('target_entered', self, 'target_reach')
		block.connect('target_exited', self, 'target_lost')
		block.set_tile_position(Vector2(block_config.tile[0], block_config.tile[1]))
		block.set_size(Vector2(block_config.size[0], block_config.size[1]))
		for j in range(block.size.y):
			for i in range(block.size.x):
				grid[block_config.tile[1]+j][block_config.tile[0]+i] = 1
		if block_config.has('target'):
			block.set_target_tile(Vector2(block_config.target[0], block_config.target[1]))
			targets_to_reach+=1
		if block_config.has('label'):
			var label = block.get_node('Label')
			label.show()
			label.text = block_config.label
		if block_config.has('lock_on_match'):
			block.lock_on_match = block_config.lock_on_match
		idx += 1
		$Blocks.add_child(block)

func pick_block(block: PuzzleBlock):
	var tile = block.tile_position
	for j in range(block.size.y):
		for i in range(block.size.x):
			grid[tile[1]+j][tile[0]+i] = 0

	# check for a limit in X
	for _i in range(0, tile.x + 1):
		var i = tile.x - _i
		var collides = false
		for size_j in range(0, block.size.y):
			if grid[tile.y+size_j][i] == 1:
				collides = true
				break
		if collides: break
		block.boundaries_x.x = block.offset.x + i*20
	
	for i in range(tile.x, grid[0].size()-(block.size.x-1)):
		var collides = false
		for size_j in range(0, block.size.y):
			if grid[tile.y+size_j][i+(block.size.x-1)] == 1:
				collides= true
				break
		if collides: break
		block.boundaries_x.y = block.offset.x + i*20
	#print(block.boundaries_x)
	
	for _i in range(0, tile.y + 1):
		var i = tile.y - _i
		var collides = false
		for size_i in range(0, block.size.x):
			if grid[i][tile.x+size_i] == 1: 
				collides = true
				break
		if collides: break
		block.boundaries_y.x = block.offset.y + i*20

	for i in range(tile.y, grid.size()-(block.size.y - 1)):
		var collides = false
		for size_i in range(0, block.size.x):
			if grid[i+(block.size.y-1)][tile.x+size_i] == 1:
				collides = true
				break
		if collides: break
		block.boundaries_y.y = block.offset.y + i*20


func update_grid(block: PuzzleBlock):
	var tile = block.tile_position
	for j in range(block.size.y):
		for i in range(block.size.x):
			grid[tile[1]+j][tile[0]+i] = 1

func target_reach():
	var targets_reached = 0
	for block in $Blocks.get_children():
		if block._matched:
			targets_reached += 1
	if targets_to_reach == targets_reached:
		$Success.show()

func target_lost():
	pass

# puzzle 0
#var config = [
#	{ 'tile': [2, 1], 'size': [1, 1], 'target': [1, 5]},
#	{ 'tile': [1, 4], 'size': [1, 1], 'target': [2, 0]},
#	{ 'tile': [0, 1], 'size': [2, 1]},
#	{ 'tile': [0, 2], 'size': [2, 1]},
#	{ 'tile': [1, 3], 'size': [2, 1]},
#	{ 'tile': [2, 4], 'size': [2, 1]},
#]

#var grid = [
#	[1,1,0,1],
#	[0,0,0,1],
#	[0,0,0,0],
#	[0,0,0,0],
#	[1,0,0,0],
#	[1,0,1,1]
#]

#var config = [
#	{ 'tile': [0, 2], 'size': [2, 1], 'target': [4, 2]},
#	{ 'tile': [0, 1], 'size': [2, 1]},
#	{ 'tile': [2, 0], 'size': [2, 1]},
#	{ 'tile': [2, 1], 'size': [2, 1]},
#	{ 'tile': [4, 0], 'size': [1, 3]},
#	{ 'tile': [5, 1], 'size': [1, 3]},
#	{ 'tile': [0, 3], 'size': [1, 2]},
#	{ 'tile': [1, 3], 'size': [1, 2]},
#	{ 'tile': [2, 3], 'size': [1, 2]},
#	{ 'tile': [3, 3], 'size': [2, 1]},
#	{ 'tile': [0, 5], 'size': [2, 1]},
#	{ 'tile': [2, 5], 'size': [2, 1]}
#]

#var grid = [
#	[0,0,0,0,0,0],
#	[0,0,0,0,0,0],
#	[0,0,0,0,0,0],
#	[0,0,0,0,0,0],
#	[0,0,0,0,0,0],
#	[0,0,0,0,0,0]
#]
