tool
extends PopochiuCharacter

var _parts_config := preload('res://popochiu/Characters/Bug/PartsConfig.gd')
var _parts_id := {}

onready var _body: Sprite = find_node('Body')
onready var _head: Sprite = find_node('Head')
onready var _legs: Sprite = find_node('Legs')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	.on_interact()


func on_look() -> void:
	.on_look()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_part(node: AttributeSelector) -> void:
	if get_node_or_null('Sprite/%s' % node.name):
		var s: Sprite = get_node('Sprite/%s' % node.name)
		s.texture = node.part.texture
		_parts_id[node.name] = node.get_part_idx()
		
		match node.name:
			'Head':
				s.offset.y = node.part.texture.get_height() / 2 * -1
			'Legs':
				s.offset.y = node.part.texture.get_height() / 2
			
		if _body:
			_head.position = Vector2(
				_get_left_position(_head),
				_body.texture.get_height() / 2 * -1
			)
			_head.position += _parts_config.body[_parts_id.Body].head
			_legs.position = Vector2(
				_get_left_position(_legs),
				_body.texture.get_height() / 2
			)
			_legs.position += _parts_config.body[_parts_id.Body].legs


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _get_left_position(target: Sprite) -> int:
	return -(_body.texture.get_width() / 2 - target.texture.get_width() / 2)
