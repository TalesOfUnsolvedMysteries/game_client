tool
extends Area2D

signal current_changed(node)
signal clicked(node)

export var texture: Texture = null setget set_texture
export var nft := ''
export var clicks_to_break := 0

var current := false setget set_current

var _shake_time := 0.0 setget set_shake_time

onready var _sprite_offset: Vector2 = $Sprite.offset


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Sprite.texture = texture
	
	if Engine.editor_hint: return
	
	connect('area_entered', self, '_area_entered')
	connect('area_exited', self, '_area_exited')
	
	enable()


func _process(delta: float) -> void:
	if _shake_time > 0:
		self._shake_time -= delta
		$Sprite.offset = _sprite_offset + Vector2(
			rand_range(-1.0, 1.0) * 1.0,
			rand_range(-1.0, 1.0) * 1.0
		)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func disable() -> void:
	monitoring = false


func enable() -> void:
	monitoring = true


func clicked() -> void:
	clicks_to_break -= 1
	if clicks_to_break > 0:
		# TODO: Dar retroalimentación del clic que intenta romper la cosa
		self._shake_time = 0.2
		return
	
	# TODO: Poner retroalimentación...
	emit_signal('clicked', self)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ set y get ░░░░
func set_texture(value: Texture) -> void:
	texture = value
	
	if has_node('Sprite'):
		$Sprite.texture = value
	
	property_list_changed_notify()


func set_current(value: bool) -> void:
	current = value
	emit_signal('current_changed', self)


func set_shake_time(value: float) -> void:
	_shake_time = value
	$Sprite.offset = Vector2.ZERO
	set_process(false if _shake_time <= 0.0 else true)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _area_entered(area2d: Area2D) -> void:
	self.current = true


func _area_exited(area2d: Area2D) -> void:
	self.current = false
