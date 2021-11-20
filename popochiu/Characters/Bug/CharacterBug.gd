tool
extends PopochiuCharacter

var _parts_config := preload('res://popochiu/Characters/Bug/PartsConfig.gd')
var _parts_id := {}

onready var _body: Sprite = find_node('Body')
onready var _head: Sprite = find_node('Head')
onready var _legs: Sprite = find_node('Legs')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _ready():
	._ready()

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
			s.offset.y = node.part.texture.get_height() / 2 * -1
		'Legs':
			s.offset.y = node.part.texture.get_height() / 2
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
	
	s.texture = node.part.texture
	
	if _body.texture and _legs.texture:
		_head.position = Vector2(
			0.0,
			(_body.texture.get_height() / 2 * -1) - 1
		)
		_legs.position = Vector2(
			0.0,
			(_body.texture.get_height() / 2) + 1
		)


func ready_to_play() -> void:
	# Poner el punto de ancla del personaje en la base
	var _offset := _legs.position.y + _legs.texture.get_height()
	_head.position.y -= _offset
	_body.position.y -= _offset
	_legs.position.y -= _offset
	
	$DialogPos.position.y = _head.position.y - _head.texture.get_height()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _get_left_position(target: Sprite) -> int:
	return -(_body.texture.get_width() / 2 - target.texture.get_width() / 2)

