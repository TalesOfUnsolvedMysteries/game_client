tool
extends Area2D

signal current_changed(node)
signal clicked(node)
signal shake_done

export var texture: Texture = null setget set_texture
export var nft := ''
export var baseline := 0 setget set_baseline
# ---- Esta propiedad podría ser única de los Breakable ------------------------
export var clicks_to_break := 0
# ---- Esta propiedad podría ser única de los Movable --------------------------


var current := false setget set_current
var path2d: Path2D = null

var _shake_time := 0.0 setget set_shake_time
var _following: Node = null

onready var _sprite_offset: Vector2 = $Sprite.offset


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Sprite.texture = texture
	
	if Engine.editor_hint:
		return
	else:
		remove_child($BaselineHelper)
		
		for c in get_children():
			if c.get_class() in [
				'Sprite', 'CollisionPolygon2D', 'CollisionShape2D', 'AnimatedSprite'
			]:
				c.position.y -= baseline * c.scale.y
		position.y += baseline * scale.y
	
	set_process(false)
	
	connect('area_entered', self, '_area_entered')
	connect('area_exited', self, '_area_exited')
	
	call_deferred('_start')
	enable()


func _process(delta: float) -> void:
	if _following:
		position = _following.global_position
		return
	
	
	self._shake_time -= delta
	$Sprite.offset = _sprite_offset + Vector2(
		rand_range(-1.0, 1.0) * 1.0,
		rand_range(-1.0, 1.0) * 1.0
	)
	
	if _shake_time <= 0.0:
		emit_signal('shake_done')
		set_process(false)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func disable() -> void:
	monitoring = false


func enable() -> void:
	monitoring = true


func clicked() -> void:
	clicks_to_break -= 1
	if clicks_to_break >= 0:
		# TODO: Dar retroalimentación del clic que intenta romper la cosa
		self._shake_time = 0.2
		
		set_process(true)
		yield(self, 'shake_done')
		
		if clicks_to_break > 0: return
	
	if _following:
		$Tween.stop(path2d.get_child(0), 'unit_offset')
		
	
	# TODO: Poner retroalimentación del objeto siendo "descubierto".
	emit_signal('clicked', self)


func continue() -> void:
	$Tween.resume(path2d.get_child(0), 'unit_offset')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ set y get ░░░░
func set_texture(value: Texture) -> void:
	texture = value
	
	if has_node('Sprite'):
		$Sprite.texture = value
	
	property_list_changed_notify()


func set_baseline(value: int) -> void:
	baseline = value
	
	if Engine.editor_hint and get_node_or_null('BaselineHelper'):
		get_node('BaselineHelper').position = Vector2.DOWN * value


func set_current(value: bool) -> void:
	current = value
	emit_signal('current_changed', self)


func set_shake_time(value: float) -> void:
	_shake_time = value
	$Sprite.offset = Vector2.ZERO
	set_process(false if _shake_time <= 0.0 else true)


func is_movable() -> bool:
	return is_instance_valid(_following)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _area_entered(area2d: Area2D) -> void:
	self.current = true


func _area_exited(area2d: Area2D) -> void:
	self.current = false


func _start() -> void:
	path2d = get_node_or_null('Path2D')
	if path2d:
		var path_follower := Node2D.new()
		path2d.get_child(0).add_child(path_follower)
		
		remove_child(path2d)
		
		get_parent().add_child(path2d)
		
		yield(get_tree(), 'idle_frame')
		
		path2d.scale = scale
		path2d.position = position
		
		$Tween.interpolate_property(
			path2d.get_child(0), 'unit_offset',
			null, 1.0,
			60.0, Tween.TRANS_LINEAR
		)
		$Tween.start()
		
		_following = path_follower
		set_process(true)
