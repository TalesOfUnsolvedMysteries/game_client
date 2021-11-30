tool
class_name Clickable
extends Area2D
# Permite definir colisiones que reaccionan a los eventos de clic y entrada y
# salida del cursor.

export var description := ''
export var clickable := true
export var baseline := 0 setget _set_baseline
export var walk_to_point: Vector2 setget _set_walk_to_point
export var look_at_point: Vector2
export(Cursor.Type) var cursor
export var script_name := ''
export var always_on_top := false

var walk_point: Vector2 setget ,_get_walk_point

onready var _description_code := description


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	connect('visibility_changed', self, '_toggle_input')

	if clickable:
		# Conectarse a eventos propios.
		connect('mouse_entered', self, '_toggle_description', [true])
		connect('mouse_exited', self, '_toggle_description', [false])
		# Conectarse a eventos globales.
		E.connect('language_changed', self, '_translate')
	
	if not Engine.editor_hint:
		remove_child($BaselineHelper)
		remove_child($WalkToHelper)
	
	set_process_unhandled_input(false)
	_translate()


func _unhandled_input(event):
	if E.is_frozen: return
	
	var mouse_event: = event as InputEventMouseButton
	var _is_pilot = NetworkManager.has_method('isPilot') and NetworkManager.isPilot()
	if mouse_event and mouse_event.pressed:
		E.clicked = self
		if event.is_action_pressed('popochiu-interact'):
			self._interact()
			if _is_pilot:
				rpc_id(1, '_net_interact')
			get_tree().set_input_as_handled()
		elif event.is_action_pressed('popochiu-look'):
			self._look()
			if _is_pilot:
				rpc_id(1, '_net_look')

remote func _net_interact():
	if NetworkManager.isServerWithPilot():
		E.clicked = self
		self._interact()

remote func _net_look():
	if NetworkManager.isServerWithPilot():
		E.clicked = self
		self._look()

func _interact():
	# TODO: Verificar si hay un elemento de inventario seleccionado
	if I.active:
		on_item_used(I.active)
	else:
		E.add_history({
			action = 'Interacted with: %s' % description
		})
		on_interact()


func _look():
	if I.active: return
	E.add_history({
		action = 'Looked at: %s' % description
	})
	on_look()


func _process(delta):
	if Engine.editor_hint:
		if walk_to_point != get_node('WalkToHelper').position:
			# Esto debería ocurrir sólo si se cambiar en el editor la posición
			# del WalkToHelper
			walk_to_point = get_node('WalkToHelper').position
			property_list_changed_notify()
		elif baseline != get_node('BaselineHelper').position.y:
			baseline = get_node('BaselineHelper').position.y
			property_list_changed_notify()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		G.display('No hay na\' pa\' hacer con esta mondá')
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		G.display('No hay nada para ver ahí')
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass


# Oculta el nodo y hace que no reciba interacciones
func disable(is_in_queue := true) -> void:
	if is_in_queue: yield()
	self.visible = false
	yield(get_tree(), 'idle_frame')


# Muestra el nodo y hace que reciba interacciones
func enable(is_in_queue := true) -> void:
	if is_in_queue: yield()
	self.visible = true
	yield(get_tree(), 'idle_frame')


func get_description() -> String:
	if Engine.editor_hint:
		if not description:
			description = name
		return description
	return E.get_text(description)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func lock() -> void:
	input_pickable = false


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _toggle_description(display: bool) -> void:
	if E.is_frozen: return
	
	set_process_unhandled_input(display)
	Cursor.set_cursor(cursor if display else null)
	if display:
		if not I.active:
			G.show_info(description)
		else:
			G.show_info('Use %s with %s' % [I.active.description, description])
	else:
		G.show_info()


func _set_baseline(value: int) -> void:
	baseline = value
	
	if Engine.editor_hint and get_node_or_null('BaselineHelper'):
		get_node('BaselineHelper').position = Vector2.DOWN * value


func _set_walk_to_point(value: Vector2) -> void:
	walk_to_point = value
	
	if Engine.editor_hint and get_node_or_null('WalkToHelper'):
		get_node('WalkToHelper').position = value
	
	if NetworkManager.has_method('isPilot') and NetworkManager.isPilot():
		rpc_id(1, '_net_set_walk_to_point', value)


remote func _net_set_walk_to_point(value: Vector2) -> void:
	if NetworkManager.isServerWithPilot():
		_set_walk_to_point(value)


func _toggle_input() -> void:
	if clickable:
		input_pickable = visible
		set_process_unhandled_input(false)


func _translate() -> void:
	if Engine.editor_hint or not is_inside_tree() or not E.use_translations: return
	description = E.get_text('%s-%s' % [get_tree().current_scene.name, _description_code])


func _get_walk_point() -> Vector2:
	return walk_to_point + position
