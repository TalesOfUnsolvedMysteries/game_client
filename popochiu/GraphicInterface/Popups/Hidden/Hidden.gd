extends "res://popochiu/Common/Overlay2D.gd"

var _is_pointer_inside := false

onready var vc: ViewportContainer = find_node('ViewportContainer')
onready var v: Viewport = find_node('Viewport')
onready var ppc: Position2D = find_node('PinchPanCamera')
onready var fp: Area2D = find_node('FakePointer')


func _ready() -> void:
	ppc.enable_pinch_pan = false
	show()
	
	ppc.connect('dragging', self, '_test')
	
	vc.connect('mouse_entered', self, '_toggle_pinch', [true])
	vc.connect('mouse_exited', self, '_toggle_pinch', [false])
	
#	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
#	connect('mouse_exited', Cursor, 'set_cursor')


func disappear() -> void:
	prints('Aquí me iría')


func _input(event: InputEvent) -> void:
	if _is_pointer_inside:
		var pos := v.canvas_transform * get_global_mouse_position()
	#	fp.position = pos + ppc.position
		fp.position = (Cursor.get_position() + ppc.position) - vc.rect_size / 2 - Vector2(29.0, 30.0)


func _test() -> void:
	prints('ppc', ppc.position)


func _toggle_pinch(enable: bool) -> void:
	_is_pointer_inside = enable
	ppc.enable_pinch_pan = enable
