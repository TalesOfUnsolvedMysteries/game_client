tool
extends PopochiuCharacter

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
	if not _was_created and E.current_room.script_name != 'BugEditor':
		Globals.set_appearance(
			str(randi() % Globals.HEADS.size()) +\
			str(randi() % Globals.BODIES.size()) +\
			str(randi() % Globals.LEGS.size()) +\
			str(randi() % Globals.EYES.size()) +\
			str(randi() % Globals.CLOTHES.size()) +\
			str(randi() % Globals.SHOES.size())
		)
		ready_to_play()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	.on_interact()


func on_look() -> void:
	.on_look()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_head(txt: Texture) -> void:
	_head.offset.y = txt.get_height() / 2 * -1
	_head.texture = txt
	
	_update_head_and_legs_positions()


func set_body(txt: Texture) -> void:
	_body.texture = txt
	
	_update_head_and_legs_positions()


func set_legs(txt: Texture) -> void:
	_legs.offset.y = txt.get_height() / 2
	_legs.texture = txt
	
	_update_head_and_legs_positions()


func set_eyes(txt: Texture) -> void:
	_eyes.position.y = -(txt.get_height() / 2) - 3.0
	_eyes.texture = txt
	
	_update_head_and_legs_positions()	


func set_clothes(txt: Texture) -> void:
	_clothes.position.x = 5.0
	_clothes.texture = txt
	
	_update_head_and_legs_positions()



func set_shoes(txt: Texture) -> void:
	_shoes.offset.y = txt.get_height() / 2 * -1
	_shoes.position.y = _legs.texture.get_height()
	_shoes.texture = txt
	
	_update_head_and_legs_positions()


func set_part(node: AttributeSelector) -> void:
	if not _body or not _head or not _legs: return
	
	var s: Sprite = $Sprite.find_node(node.name)
	
	match node.name:
		'Head':
			set_head(node.part.texture)
		'Legs':
			set_legs(node.part.texture)
		'Eyes', 'Clothes', 'Shoes':
			if node.get_part_idx() == -1:
				s.texture = null
				return
			continue
		'Eyes':
			set_eyes(node.part.texture)
		'Clothes':
			set_clothes(node.part.texture)
		'Shoes':
			set_shoes(node.part.texture)
		_:
			set_body(node.part.texture)


func ready_to_play() -> void:
	# Poner el punto de ancla del personaje en la base
	var _offset := _legs.position.y + _legs.texture.get_height()
	_head.position.y -= _offset
	_body.position.y -= _offset
	_legs.position.y -= _offset
	
	$DialogPos.position.y = _head.position.y - _head.texture.get_height()
	
#	_was_created = true

func get_adn():
	return '000000'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _get_left_position(target: Sprite) -> int:
	return -(_body.texture.get_width() / 2 - target.texture.get_width() / 2)


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
