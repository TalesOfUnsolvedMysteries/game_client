tool
extends PopochiuCharacter

var _parts_id := {}
var _was_created := false

onready var _body: Sprite = find_node('Body')
onready var _arms: Sprite = find_node('Arms')
onready var _head: Sprite = find_node('Head')
onready var _eyes: Sprite = find_node('Eyes')
onready var _legs: Sprite = find_node('Legs')
onready var _shoes: Sprite = find_node('Shoes')
onready var _dflts := {}


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _ready():
	# Cargar por defecto partes aleatorias para facilitar las pruebas de las
	# habitaciones.
	if not Engine.editor_hint\
	and not _was_created and E.current_room.script_name != 'BugEditor':
		if Globals.bug_adn.empty():
			Globals.set_appearance(
				str(randi() % (Globals.HEADS.size() - 1)) +\
				str(randi() % (Globals.BODIES.size() - 1)) +\
				str(randi() % Globals.LEGS.size()) +\
				str(randi() % Globals.EYES.size()) +\
				str(randi() % Globals.ARMS.size()) +\
				str(randi() % Globals.SHOES.size())
			)
		else:
			load_appearance(Globals.bug_adn)
		_was_created = true
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
	if txt:
		_eyes.position.y = -(txt.get_height() / 2) - 3.0
		_eyes.texture = txt
	else:
		_eyes.texture = null
	
	_update_head_and_legs_positions()


func set_arms(txt: Texture) -> void:
	if txt: _arms.position.x = 5.0
	_arms.texture = txt
	
	_update_head_and_legs_positions()


func set_shoes(txt: Texture) -> void:
	if txt:
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
		'Eyes', 'Arms', 'Shoes':
			if node.get_part_idx() == -1:
				s.texture = null
				return
			continue
		'Eyes':
			set_eyes(node.part.texture)
		'Arms':
			set_arms(node.part.texture)
		'Shoes':
			set_shoes(node.part.texture)
		_:
			set_body(node.part.texture)


func ready_to_play() -> void:
	_update_head_and_legs_positions()
	
	if not _dflts:
		_dflts = {
			head_y = _head.position.y,
			body_y = _body.position.y,
			legs_y = _legs.position.y
		}
	
	# Poner el punto de ancla del personaje en la base
	var _offset: float = _dflts.legs_y + _legs.texture.get_height()
	_head.position.y = _dflts.head_y - _offset
	_body.position.y = _dflts.body_y -_offset
	_legs.position.y = _dflts.legs_y -_offset
	
	$DialogPos.position.y = _head.position.y - _head.texture.get_height()
	
#	_was_created = true


func load_appearance(adn: String):
	_body.position.y = 0
	
	for idx in adn.length():
		match idx:
			0:
				set_head(Globals.HEADS[int(adn[idx])])
			1:
				set_body(Globals.BODIES[int(adn[idx])])
			2:
				set_legs(Globals.LEGS[int(adn[idx])])
			3:
				if adn[idx] == 'x': set_eyes(null)
				else: set_eyes(Globals.EYES[int(adn[idx])])
			4:
				if adn[idx] == 'x': set_arms(null)
				else: set_arms(Globals.ARMS[int(adn[idx])])
			5:
				if adn[idx] == 'x': set_shoes(null)
				else: set_shoes(Globals.SHOES[int(adn[idx])])
	
	ready_to_play()
	#if E.current_room.script_name == 'BugEditor':
	#	ready_to_play()


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
