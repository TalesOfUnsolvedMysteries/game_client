extends "res://popochiu/Common/Overlay2D.gd"

const CLUES_FILE := preload('HiddenClues.gd')

var goals := {}

var _is_pointer_inside := false
var _is_dragging := false
var _current_obj: Area2D = null
var _found_goals := 0
var _obj_behind: Area2D = null
var _level_goals := 0

onready var vc: ViewportContainer = find_node('ViewportContainer')
onready var v: Viewport = find_node('Viewport')
onready var ppc: Position2D = find_node('PinchPanCamera')
onready var fp: Area2D = find_node('FakePointer')
onready var level: YSort = find_node('Level')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	ppc.enable_pinch_pan = false
	
	# Conectarse a señales de las hijas
	vc.connect('mouse_entered', self, '_toggle_pinch', [true])
	vc.connect('mouse_exited', self, '_toggle_pinch', [false])
	ppc.connect('dragging', self, '_camera_dragging')
	$GI.connect('click_limit_reached', self, '_lose')
	
	_start()


func _input(event: InputEvent) -> void:
	if _is_pointer_inside:
		# Calcular la posición del puntero pa' poner ahí el área que va a
		# detectar las colisiones con los objetos del nivel
		fp.position = Cursor.get_position() - vc.rect_size * 0.5
		fp.position -= Vector2(29.0, 30.0)
		fp.position *= ppc.camera.zoom
		fp.position += ppc.position
		
		if _current_obj and _current_obj.is_draggable:
			_current_obj.mouse_position = fp.position
		
		var mouse_event: = event as InputEventMouseButton
		if mouse_event and mouse_event.button_index == BUTTON_LEFT:
			get_tree().set_input_as_handled()
			$GI.hide_tooltip()
			
			if mouse_event.pressed:
				_is_dragging = false
				
				if _current_obj and _current_obj.is_draggable:
					ppc.enable_pinch_pan = false
					
					_current_obj.pressed()
			else:
				# Aquí es donde pasan las cosas importantes
				if _current_obj and _current_obj.is_draggable:
					_current_obj.set_process_input(false)
					
					ppc.already_pressed = false
					ppc.enable_pinch_pan = true
				elif not _is_dragging and _current_obj:
					_current_obj.clicked()
				elif not _is_dragging and not _current_obj:
					$GI.count_try_click()
				
				_is_dragging = false


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _appeared() -> void:
	for o in level.get_node('Objects').get_children():
		if o.is_movable():
			o.move()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _start() -> void:
	for o in level.get_node('Objects').get_children():
		if CLUES_FILE.CLUES.has(o.name):
			_level_goals += 1
			$GI.add_goal(_get_goal_data(o.name))
		
		o.connect('current_changed', self, '_assign_current')
		o.connect('clicked', self, '_check_clicked')


func _toggle_pinch(enable: bool) -> void:
	_is_pointer_inside = enable
	ppc.enable_pinch_pan = enable


func _camera_dragging() -> void:
	_is_dragging = true


func _assign_current(obj: Area2D) -> void:
	if _current_obj and _current_obj != obj:
		_obj_behind = obj
		return
	elif _current_obj and _current_obj.is_processing_input():
		return
	
	_current_obj = obj if obj.current else null
	_obj_behind = null


func _check_clicked(obj: Area2D) -> void:
	var first_part: String = obj.name.capitalize().split(' ')[0]
	match first_part:
		'Stone', 'Breakable':
			obj.hide()
			continue
		'Stone':
			var stone_name := obj.name.capitalize().to_upper().split(' ').join('_')
			yield(_give_nft(stone_name), 'completed')
			# TODO: ¿Agregar la piedra al inventario? ¿O notificar que la
			# piedra ya está disponible para ser sacada de la máquina?
		_:
			if $GI.check_clicked(obj.name):
				obj.disable()
				
				# Que la cámara se centre en el coso recién encontrado
				ppc.moving_to = obj.position + Vector2.DOWN * 4.0
				
				yield(ppc, 'movement_done')
				
				if obj.nft:
					yield(_give_nft(obj.nft), 'completed')
				
				# Mostrar la interfaz
				$GI.show_details(_get_goal_data(obj.name))
				
				yield($GI, 'details_closed')
				
				if obj.is_movable():
					obj.move()
				
				if _obj_behind:
					_current_obj = _obj_behind
					_obj_behind = null
				else:
					_current_obj = null
				
				_found_goals += 1
				if _found_goals == _level_goals:
					_win()
					return


func _win() -> void:
	prints('¡¡¡  G A N A T E S  !!!')


func _lose() -> void:
	prints('~~~ perdites ~~~')


func _give_nft(nft_name: String) -> void:
	Globals.set_state('Hidden-' + nft_name, true)
	
	yield(E.run([
		E.runnable(
			G,
			'emit_signal',
			['nft_won', Globals.NFTs[nft_name]],
			'nft_shown'
		),
	]), 'completed')


func _get_goal_data(obj_name: String) -> Dictionary:
	var data := (CLUES_FILE.CLUES[obj_name] as Dictionary).duplicate()
	data.obj = obj_name
	
	return data
