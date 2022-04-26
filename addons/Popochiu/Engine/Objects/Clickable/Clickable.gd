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
var room: Node2D = null

onready var _description_code := description


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _enter_tree() -> void:
	add_to_group('Clickable')


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
	else:
		hide_helpers()
	
	set_process_unhandled_input(false)
	_translate()


func _unhandled_input(event):
	if E.is_frozen: return
	
	var mouse_event: = event as InputEventMouseButton
	if mouse_event and mouse_event.pressed:
#		E.clicked = self
		if event.is_action_pressed('popochiu-interact'):
			Utils.invoke(self, '_interact')
			get_tree().set_input_as_handled()
		elif event.is_action_pressed('popochiu-look'):
			Utils.invoke(self, '_look')


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
func hide_helpers() -> void:
	$BaselineHelper.hide()
	$WalkToHelper.hide()


func show_helpers() -> void:
	$BaselineHelper.show()
	$WalkToHelper.show()


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


func _interact():
	E.clicked = self
	
	if I.active:
		on_item_used(I.active)
	else:
		E.add_history({
			action = 'Interacted with: %s' % description
		})
		on_interact()


func _look():
	E.clicked = self
	
	if I.active: return
	E.add_history({
		action = 'Looked at: %s' % description
	})
	on_look()


func _set_baseline(value: int) -> void:
	baseline = value
	
	if Engine.editor_hint and get_node_or_null('BaselineHelper'):
		get_node('BaselineHelper').position = Vector2.DOWN * value


func _set_walk_to_point(value: Vector2) -> void:
	walk_to_point = value
	
	if Engine.editor_hint and get_node_or_null('WalkToHelper'):
		get_node('WalkToHelper').position = value
	
	if not Engine.editor_hint:
		if NetworkManager.has_method('isPilot') and NetworkManager.isPilot()\
		and is_inside_tree():
			Utils.invoke(self, '_set_walk_to_point', [value], true)


func _toggle_input() -> void:
	if clickable:
		input_pickable = visible
		set_process_unhandled_input(false)


func _translate() -> void:
	if Engine.editor_hint or not is_inside_tree() or not E.use_translations: return
	description = E.get_text('%s-%s' % [get_tree().current_scene.name, _description_code])


func _get_walk_point() -> Vector2:
	return walk_to_point + position
