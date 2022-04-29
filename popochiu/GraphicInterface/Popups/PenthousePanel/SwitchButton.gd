extends Button

const BUTTON_NORMAL_CELL: StyleBoxTexture=\
 preload('styles/ButtonNormalCellTexture.tres')
const NORMAL_CELL_TEXTURE: Texture = preload('sprites/button_normal_cell.png')
const PRESSED_CELL_TEXTURE: Texture = preload('sprites/button_pressed_cell.png')

onready var lights = find_node('FloorsList')


func _ready():
	for j in range(0, 9):
		var cell: Label = lights.get_child(8 - j)
		cell.add_stylebox_override('normal', BUTTON_NORMAL_CELL.duplicate())


func set_lights(switch):
	for j in range(0, 9):
		var active = (int(switch) & int(pow(2, j))) > 0
		var cell: Label = lights.get_child(8 - j)
		var cell_texture: StyleBoxTexture = cell.get_stylebox('normal')
		
		if active:
			cell_texture.region_rect.position.x = 8
		else:
			cell_texture.region_rect.position.x = 0


func _toggled(pressed):
	for j in range(0, 9):
		var cell: Label = lights.get_child(8 - j)
		var cell_texture: StyleBoxTexture = cell.get_stylebox('normal')
		var region_offset: float = cell_texture.region_rect.position.x
		
		if pressed:
			cell_texture.texture = PRESSED_CELL_TEXTURE
		else:
			cell_texture.texture = NORMAL_CELL_TEXTURE
		
		cell_texture.region_rect.size = Vector2(8.0, 8.0)
		cell_texture.region_rect.position.x = region_offset
