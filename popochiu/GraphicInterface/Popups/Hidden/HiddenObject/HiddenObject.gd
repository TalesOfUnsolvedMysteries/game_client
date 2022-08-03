tool
extends Area2D

signal current_changed(node)
signal clicked(node)
signal shake_done

export var texture: Texture = null setget set_texture
export var nft := ''
export var baseline := 0 setget set_baseline
# ---- Breakable ---------------------------------------------------------------
export var clicks_to_break := 0
# ---- Draggable ---------------------------------------------------------------
export var is_draggable := false
#export (int, "Normal", "Horizontal", "Vertical") var slide_mode = 0
export(int, 'Horizontal', 'Vertical') var slide_mode := 0
export var max_distance := INF


var current := false setget set_current
var path2d: Path2D = null

# ---- Breakable ---------------------------------------------------------------
var _shake_time := 0.0 setget set_shake_time
# ---- Movable -----------------------------------------------------------------
var _following: Node = null
# ---- Draggable ---------------------------------------------------------------
var _is_dragging := false
var _start_position := Vector2.ZERO

# ---- Draggable ---------------------------------------------------------------
var mouse_position := Vector2.INF


onready var _sprite_offset: Vector2 = $Sprite.offset


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Sprite.texture = texture
	
	if Engine.editor_hint:
		return
	else:
		remove_child($BaselineHelper)
		
		# Recalcular posiciones para que la configuración hecha para el baseline
		# se aplique a las coordenadas reales del objeto
		for c in get_children():
			if c.get_class() in [
				'Sprite', 'CollisionPolygon2D', 'CollisionShape2D', 'AnimatedSprite'
			]:
				c.position.y -= baseline * c.scale.y
		position.y += baseline * scale.y
	
	connect('area_entered', self, '_area_entered')
	connect('area_exited', self, '_area_exited')
	
	if has_node('Path2D'):
		call_deferred('_start')
	
	if is_draggable:
		_start_position = position
	
	enable()
	set_process(false)
	
	set_process_input(false)


func _process(delta: float) -> void:
	# ---- Movable -------------------------------------------------------------
	if _following:
		position = _following.global_position
		return
	
	# ---- Breakable -----------------------------------------------------------
	self._shake_time -= delta
	$Sprite.offset = _sprite_offset + Vector2(
		rand_range(-1.0, 1.0) * 1.0,
		rand_range(-1.0, 1.0) * 1.0
	)
	
	if _shake_time <= 0.0:
		emit_signal('shake_done')
		set_process(false)


func _input(event: InputEvent):
	if event is InputEventScreenDrag:
		var coord = _get_movement_vector_from(-to_local(mouse_position))
		position += coord
		
		if _start_position.distance_to(position) > max_distance:
			if slide_mode == 0:
				if position.x - _start_position.x < 0:
					position.x = _start_position.x - max_distance
				else:
					position.x = _start_position.x + max_distance
			else:
				if position.y - _start_position.y < 0:
					position.y = _start_position.y - max_distance
				else:
					position.y = _start_position.y + max_distance


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func disable() -> void:
	monitoring = false


func enable() -> void:
	monitoring = true


func clicked() -> void:
	# ---- Breakable -----------------------------------------------------------
	clicks_to_break -= 1
	if clicks_to_break >= 0:
		# TODO: Dar retroalimentación del clic que intenta "romper" la cosa
		self._shake_time = 0.2
		
		set_process(true)
		yield(self, 'shake_done')
		
		if clicks_to_break > 0: return
	
	# ---- Movable -------------------------------------------------------------
	if _following:
		set_process(false)
		$Tween.stop(path2d.get_child(0), 'unit_offset')
		
		yield(get_tree().create_timer(0.2), 'timeout')
	
	# ---- Todos ---------------------------------------------------------------
	# TODO: Poner retroalimentación del objeto siendo "descubierto".
	emit_signal('clicked', self)


# ---- Movable -----------------------------------------------------------------
func move() -> void:
	if $Tween.is_active():
		yield(get_tree().create_timer(0.2), 'timeout')
		
		$Tween.resume(path2d.get_child(0), 'unit_offset')
	else:
		$Tween.interpolate_property(
			path2d.get_child(0), 'unit_offset',
			null, 1.0,
			60.0, Tween.TRANS_LINEAR
		)
		$Tween.start()
	
	set_process(true)


# ---- Draggable -----------------------------------------------------------
func pressed() -> void:
	_is_dragging = true
	
	set_process_input(true)


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
		
		get_node('../../').add_child(path2d)
		
		yield(get_tree(), 'idle_frame')
		
		path2d.scale = scale
		path2d.position = position
		
		_following = path_follower


func _get_movement_vector_from(vec : Vector2) -> Vector2:
	var move_vec = Vector2.ZERO - vec 
	
	if slide_mode == 0:
		return Vector2(move_vec.x, 0)
	if slide_mode == 1:
		return Vector2(0, move_vec.y)
	else:
		return move_vec
