tool
class_name AttributeSelector
extends PanelContainer

signal part_updated(node)

export var title := ''
export var main_color: Color = Color.white
export(Array, Texture) var parts = []
export var shadow_texture: Texture = null
export var has_none := false

var _current_part := 0 setget _set_current_part
var _none_texture: Texture =\
preload('res://popochiu/Rooms/BugEditor/AttributeSelector/none.png')
#var _name_template := '[center][wave amp=%d freq=%d]%s[/wave][/center]'
var _name_template := '[center][shake]%s[/shake][/center]'

onready var _name: RichTextLabel = find_node('Name')
onready var btn_left: TextureButton = find_node('Left')
onready var btn_right: TextureButton = find_node('Right')
onready var part: TextureRect = find_node('Part')
onready var shadow: TextureRect = find_node('Shadow')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	randomize()
	var amp := randi() % 10 + 5
	var freq := randi() % 8 + 5
	_name.bbcode_text = _name_template % [title]
	_name.add_color_override('default_color', main_color)
	shadow.texture = shadow_texture
	
	if not Engine.editor_hint and has_none:
		parts.push_front(_none_texture)
	
	_update_part()
	_check_buttons()
	
	btn_left.connect('pressed', self, '_sum_part', [-1])
	btn_right.connect('pressed', self, '_sum_part', [1])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func get_part_idx() -> int:
	return _current_part if not has_none else _current_part - 1


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _sum_part(amount: int) -> void:
	if amount < 0:
		self._current_part = max(0, _current_part + amount)
	else:
		self._current_part = min(parts.size(), _current_part + amount)


func _update_part() -> void:
	part.texture = parts[_current_part]
	
	C.player.set_part(self)


func _check_buttons() -> void:
	btn_left.disabled = _current_part == 0
	btn_right.disabled = _current_part == parts.size() - 1


func _set_current_part(value: int) -> void:
	_current_part = value
	_update_part()
	_check_buttons()
