tool
extends PopochiuCharacter

var _parts_config := preload('res://popochiu/Characters/Bug/PartsConfig.gd')
var _parts_id := {}
var _was_created := false

onready var _body: Sprite = find_node('Body')
onready var _clothes: Sprite = find_node('Clothes')
onready var _head: Sprite = find_node('Head')
onready var _eyes: Sprite = find_node('Eyes')
onready var _legs: Sprite = find_node('Legs')
onready var _shoes: Sprite = find_node('Shoes')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _ready():
	._ready()
	
	# Cargar por defecto partes aleatorias para facilitar las pruebas de las
	# habitaciones.
	if not _was_created and E.current_room.script_name:
		_set_body(Utils.get_random_array_element(
			[
				preload('res://popochiu/Characters/Bug/parts/body_bee.png'),
				preload('res://popochiu/Characters/Bug/parts/body_beetle.png'),
				preload('res://popochiu/Characters/Bug/parts/body_ladybird.png'),
			]
		))
		_set_head(Utils.get_random_array_element(
			[
				preload('res://popochiu/Characters/Bug/parts/head_bee.png'),
				preload('res://popochiu/Characters/Bug/parts/head_beetle.png'),
				preload('res://popochiu/Characters/Bug/parts/head_ladybird.png'),
			]
		))
		_set_legs(Utils.get_random_array_element(
			[
				preload('res://popochiu/Characters/Bug/parts/legs_bee.png'),
				preload('res://popochiu/Characters/Bug/parts/legs_beetle.png'),
				preload('res://popochiu/Characters/Bug/parts/legs_ladybird.png'),
			]
		))
		ready_to_play()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	.on_interact()


func on_look() -> void:
	.on_look()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_part(node: AttributeSelector) -> void:
	if not _body or not _head or not _legs: return
	
	var s: Sprite = $Sprite.find_node(node.name)
	
	match node.name:
		'Head':
			_set_head(node.part.texture)
		'Legs':
			_set_legs(node.part.texture)
		'Eyes', 'Clothes', 'Shoes':
			if node.get_part_idx() == -1:
				s.texture = null
				return
			continue
		'Eyes':
			s.position.y = -(node.part.texture.get_height() / 2) - 3.0
		'Clothes':
			s.position.x = 5.0
		'Shoes':
			s.offset.y = node.part.texture.get_height() / 2 * -1
			s.position.y = _legs.texture.get_height()
		_:
			_set_body(node.part.texture)
	
	s.texture = node.part.texture
	
	_update_head_and_legs_positions()


func ready_to_play() -> void:
	# Poner el punto de ancla del personaje en la base
	var _offset := _legs.position.y + _legs.texture.get_height()
	_head.position.y -= _offset
	_body.position.y -= _offset
	_legs.position.y -= _offset
	
	$DialogPos.position.y = _head.position.y - _head.texture.get_height()
	
#	_was_created = true


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _get_left_position(target: Sprite) -> int:
	return -(_body.texture.get_width() / 2 - target.texture.get_width() / 2)


func _set_head(txt: Texture) -> void:
	_head.offset.y = txt.get_height() / 2 * -1
	_head.texture = txt
	
	_update_head_and_legs_positions()


func _set_legs(txt: Texture) -> void:
	_legs.offset.y = txt.get_height() / 2
	_legs.texture = txt
	
	_update_head_and_legs_positions()


func _set_body(txt: Texture) -> void:
	_body.texture = txt
	
	_update_head_and_legs_positions()


func _update_head_and_legs_positions() -> void:
	if _body.texture and _legs.texture:
		_head.position = Vector2(
			0.0,
			(_body.texture.get_height() / 2 * -1) - 1
		)
		_legs.position = Vector2(
			0.0,
			(_body.texture.get_height() / 2) + 1
		)
