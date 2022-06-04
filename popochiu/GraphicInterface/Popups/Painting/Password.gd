extends GridContainer

const FireTexture: AtlasTexture = preload('FireTexture.tres')

onready var _fire_left := preload('Fire.tscn').instance()
onready var _fire_right := preload('Fire.tscn').instance()
onready var _beetle := preload('Beetle.tscn').instance()
onready var _bee := preload('Bee.tscn').instance()
onready var _lady_bird := preload('LadyBird.tscn').instance()
onready var _rooster := preload('Rooster.tscn').instance()
onready var _totem := preload('Totem.tscn').instance()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	for tr in _fire_left.get_children():
		(tr as TextureRect).texture = FireTexture.duplicate()
	
	for tr in _fire_right.get_children():
		(tr as TextureRect).texture = FireTexture.duplicate()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func setup(config: Dictionary) -> void:
	print('setup this')
	print(config)
	for i in 6:
		for j in 6:
			var key := '%d,%d' % [i, j]
			
			if config.has(key):
				match config[key][0]:
					'L':
						_setup_fire(_fire_left, config[key].substr(1))
						add_child(_fire_left)
					'A':
						add_child(_beetle)
					'B':
						add_child(_lady_bird)
					'C':
						add_child(_bee)
					'D':
						add_child(_rooster)
					'E':
						add_child(_totem)
					'R':
						_setup_fire(_fire_right, config[key].substr(1))
						add_child(_fire_right)
			else:
				var space := ColorRect.new()
				space.modulate = Color('a675fe')
				#space.modulate.a = 0.0
				space.rect_min_size = Vector2(8, 10)
				
				add_child(space)
	
#	_setup_fire(_fire_left, code.substr(0, 3))
#	add_child(_fire_left)
#
#	for idx in range(3, 8):
#		match code[idx]:
#			'A':
#				add_child(_beetle)
#			'B':
#				add_child(_lady_bird)
#			'C':
#				add_child(_bee)
#			'D':
#				add_child(_rooster)
#			'E':
#				add_child(_totem)
#
#	_setup_fire(_fire_right, code.substr(8))
#	add_child(_fire_right)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _setup_fire(fire: HBoxContainer, code: String) -> void:
	for tr in fire.get_children():
		tr.texture.region.position.x = 0.0
		if code[tr.get_index()] == '1':
			tr.texture.region.position.x = 2.0
