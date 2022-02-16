extends Node2D
const Block = preload("res://popochiu/GraphicInterface/Puzzles/Block.tscn")

signal solved

export var id := ''
export(Array, Texture) var blocks_textures := []
export var show_labels := true
export var lock_on_success := true

var config = [
	{ 'tile': Vector2(1, 1), 'size': [1, 1], 'target': Vector2(2, 0), 'label': '3', 'lock_on_match': false, textures_idx = 2},
	{ 'tile': Vector2(2, 0), 'size': [1, 1], 'target': Vector2(1, 1), 'label': '5', 'lock_on_match': false, textures_idx = 4},
	{ 'tile': Vector2(0, 1), 'size': [1, 1], 'target': Vector2(0, 2), 'label': '7', 'lock_on_match': false, textures_idx = 6},
	{ 'tile': Vector2(0, 0), 'size': [1, 1], 'target': Vector2(0, 0), 'label': '1', 'lock_on_match': false, textures_idx = 0},
	{ 'tile': Vector2(1, 0), 'size': [1, 1], 'target': Vector2(2, 1), 'label': '6', 'lock_on_match': false, textures_idx = 5},
	{ 'tile': Vector2(2, 1), 'size': [1, 1], 'target': Vector2(1, 2), 'label': '8', 'lock_on_match': false, textures_idx = 7},
	{ 'tile': Vector2(2, 2), 'size': [1, 1], 'target': Vector2(1, 0), 'label': '2', 'lock_on_match': false, textures_idx = 1},
	{ 'tile': Vector2(1, 2), 'size': [1, 1], 'target': Vector2(0, 1), 'label': '4', 'lock_on_match': false, textures_idx = 3}
]

var grid = [
	[0,0,0],
	[0,0,0],
	[0,0,0]
]

var offset = Vector2(0, 0)
var targets_to_reach = 0

func _ready():
	connect('visibility_changed', self, '_toggle_blocks')
	
	var idx = 0
	offset.x = grid[0].size()*-10 + 10
	offset.y = grid.size()*-10 + 10
	targets_to_reach = 0
	for block_config in config:
		var block = $Blocks.get_children()[idx]
		block.offset = offset
		
		# Verificar si en el Globals hay una posición guardada para la pieza
		if Globals.puzzle_state.has(id)\
		and Globals.puzzle_state[id].has(var2str(block_config.target)):
			block_config.tile = str2var(
				Globals.puzzle_state[id][var2str(block_config.target)]
			)
		
		block.connect('drag_started', self, 'pick_block')
		block.connect('drag_ended', self, 'update_grid')
		block.connect('target_entered', self, 'target_reach')
		block.connect('target_exited', self, 'target_lost')
		block.set_size(Vector2(block_config.size[0], block_config.size[1]))
		
		for j in range(block.size.y):
			for i in range(block.size.x):
				grid[block_config.tile.y + j][block_config.tile.x + i] = 1
		
		# Definir la posición objetivo de la pieza
		if block_config.has('target'):
			block.set_target_tile(block_config.target)
			targets_to_reach+=1
		
		# Asignar y mostrar el texto de la pieza
		if show_labels and block_config.has('label'):
			var label = block.get_node('Label')
			label.show()
			label.text = block_config.label
		
		if block_config.has('lock_on_match'):
			block.lock_on_match = block_config.lock_on_match
		
		if not blocks_textures.empty() and block_config.has('textures_idx'):
			block.set_texture(blocks_textures[block_config.textures_idx])
		
		block.set_tile_position(block_config.tile)
		block.visible = visible
		
		idx += 1

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
			
	# Guardar el estado de las piezas.
	if not Globals.puzzle_state.has(id):
		Globals.puzzle_state[id] = {}
	
	Globals.puzzle_state[id][var2str(block.target_tile)] = var2str(tile)

func target_reach():
	var targets_reached = 0
	for block in $Blocks.get_children():
		if block._matched:
			targets_reached += 1
	if targets_reached >= targets_to_reach:
		if lock_on_success:
			for block in $Blocks.get_children():
				block.locked = true
		emit_signal('solved')

func target_lost():
	pass


func _toggle_blocks() -> void:
	for b in $Blocks.get_children():
		b.visible = visible

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
