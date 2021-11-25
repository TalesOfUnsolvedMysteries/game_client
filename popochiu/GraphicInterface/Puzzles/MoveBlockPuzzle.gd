extends Node2D
const Block = preload("res://popochiu/GraphicInterface/Puzzles/Block.tscn")
var config = [[0,0,2,1],[0,1,1,2],[2,0,1,3],[1,1,1,1]]
var grid = [
	[0,0,0,0,1],
	[0,0,0,0,0],
	[0,0,0,0,0],
	[0,0,0,0,0],
	[1,1,0,1,1]
]
func _ready():
	var idx = 0
	for block_config in config:
		var block = Block.instance()
	
	#for block in $Blocks.get_children():
	#	var tile = config[idx]
		block.offset = Vector2(-40, -40)
		block.connect('drag_started', self, 'pick_block')
		block.connect('drag_ended', self, 'update_grid')
		block.set_tile_position(Vector2(block_config[0], block_config[1]))
		block.set_size(Vector2(block_config[2], block_config[3]))
		for j in range(block.size.y):
			for i in range(block.size.x):
				grid[block_config[1]+j][block_config[0]+i] = 1
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

	for _i in range(0, tile.y + 1):
		var i = tile.y - _i
		var collides = false
		for size_i in range(0, block.size.x):
			if grid[i][tile.x+size_i] == 1: 
				collides = true
				break
		if collides: break
		block.boundaries_y.x = block.offset.y + i*20
	
	for i in range(tile.y, grid[1].size()-(block.size.y - 1)):
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
