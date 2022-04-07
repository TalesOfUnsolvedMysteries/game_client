extends Control
class_name InventoryItem, 'res://addons/Popochiu/icons/inventory_item.png'
# Estos son los objetos que podrán ir al inventario:
# GraphicInterfaceLayer > InventoryContainer > ... > InventoryGrid

signal description_toggled(description)
signal selected(item)

export var description := ''
export var stack := false
export var script_name := ''
export(Cursor.Type) var cursor
export var pickup_location := ''

var amount := 1
var in_inventory := false setget _set_in_inventory


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	connect('mouse_entered', self, '_toggle_description', [true])
	connect('mouse_exited', self, '_toggle_description', [false])
	connect('gui_input', self, '_on_action_pressed')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
# Cuando se le hace clic en el inventario
func on_interact() -> void:
	emit_signal('selected', self)


# Lo que pasará cuando se haga clic derecho en el icono del inventario
func on_look() -> void:
	pass


# Lo que pasará cuando se use otro InventoryItem del inventario sobre este
func on_item_used(_item: InventoryItem) -> void:
	pass


func added_to_inventory() -> void:
	Globals.set_state(pickup_location, false)

func on_discard () -> void:
	Globals.set_state(pickup_location, true)

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _toggle_description(display: bool) -> void:
	Cursor.set_cursor(cursor if display else null)
	G.show_info(description if display else '')
	emit_signal('description_toggled', description if display else '')


func _on_action_pressed(event: InputEvent) -> void: 
	var mouse_event := event as InputEventMouseButton
	
	if mouse_event:
		if mouse_event.is_action_pressed('popochiu-interact'):
			print('popochiu inv item interact')  # CHECK
			if I.active:
				Utils.invoke(self, 'on_item_used', [I.active])
			else:
				Utils.invoke(self, 'on_interact')
		elif mouse_event.is_action_pressed('popochiu-look'):
			Utils.invoke(self, 'on_look')


func _get_description() -> String:
	if Engine.editor_hint:
		if not description:
			description = name
		return description
	return E.get_text(description)


func _set_in_inventory(value: bool) -> void:
	in_inventory = value
	
	if in_inventory: added_to_inventory()
