class_name InventoryContainer
extends Control

signal item_added(item)

var is_disabled := false

var _can_hide_inventory := true

onready var _hide_y := rect_position.y - (rect_size.y - 3.5)
onready var _foreground: TextureRect = find_node('InventoryForeground')
onready var _grid: GridContainer = find_node('InventoryGrid')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	rect_size.x = _foreground.rect_size.x
	
	if not E.inventory_always_visible:
		rect_position.y = _hide_y
		
		# Conectarse a señales del yo
		connect('mouse_entered', self, '_open')
		connect('mouse_exited', self, '_close')
	
	$BtnDiscard.connect('pressed', self, '_discard_item')
	$BtnDiscard.connect('mouse_entered', self, '_show_info')
	$BtnDiscard.connect('mouse_exited', self, '_hide_info')
	
	# Conectarse a las señales del papá de los inventarios
	I.connect('item_added', self, '_add_item')
	I.connect('item_removed', self, '_remove_item')
	
	if I.get_child_count() == 0:
		$BtnDiscard.disabled = true


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func disable() -> void:
	is_disabled = true
	
	if E.inventory_always_visible:
		hide()
	else:
		$Tween.interpolate_property(
			self, 'rect_position:y',
			_hide_y, _hide_y - 3.5,
			0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		$Tween.start()


func enable() -> void:
	is_disabled = false
	
	if E.inventory_always_visible:
		show()
	else:
		$Tween.interpolate_property(
			self, 'rect_position:y',
			_hide_y - 3.5, _hide_y,
			0.3, Tween.TRANS_SINE, Tween.EASE_OUT
		)
		$Tween.start()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _open() -> void:
	if E.inventory_always_visible: return
	if not is_disabled and rect_position.y != _hide_y: return
	
	$Tween.interpolate_property(
		self, 'rect_position:y',
		_hide_y if not is_disabled else rect_position.y, 0.0,
		0.5, Tween.TRANS_EXPO, Tween.EASE_OUT
	)
	$Tween.start()


func _close() -> void:
	if E.inventory_always_visible: return
	
	yield(get_tree(), 'idle_frame')
	
	if not _can_hide_inventory: return
	
	$Tween.interpolate_property(
		self, 'rect_position:y',
		0.0, _hide_y if not is_disabled else _hide_y - 3.5,
		0.2, Tween.TRANS_SINE, Tween.EASE_IN
	)
	$Tween.start()


func _show_item_info(description := '') -> void:
	_can_hide_inventory = false if description else true


func _change_cursor(item: InventoryItem) -> void:
	I.set_active_item(item, false)


func _add_item(item: InventoryItem) -> void:
	_grid.add_child(item)
	
	item.connect('description_toggled', self, '_show_item_info')
	item.connect('selected', self, '_change_cursor')
	
	if not E.inventory_always_visible:
		_open()
		yield(get_tree().create_timer(2.0), 'timeout')
		_close()
	else:
		yield(get_tree(), 'idle_frame')

	I.emit_signal('item_add_done', item)
	
	$BtnDiscard.disabled = false


func _remove_item(item: InventoryItem) -> void:
	item.disconnect('description_toggled', self, '_show_item_info')
	item.disconnect('selected', self, '_change_cursor')
	_grid.remove_child(item)
	
	yield(get_tree(), 'idle_frame')
	
	I.emit_signal('item_remove_done', item)
	
	if _grid.get_child_count() == 0:
		$BtnDiscard.disabled = true


func _discard_item() -> void:
	if I.active:
		I.discard_item(I.active.script_name, false)


func _show_info() -> void:
	if I.active:
		G.show_info('Click to discard %s' % I.active.description)
	else:
		G.show_info('Use this to discard inventory items')


func _hide_info() -> void:
	G.show_info()
