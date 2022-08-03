extends "res://popochiu/Common/Overlay2D.gd"

var _in_umbrella := false setget set_in_umbrella
var _choosing_point := true
var _choosing_height := false
var _direction := 1


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if Engine.editor_hint: return
	
	$Floor.connect('mouse_entered', Cursor, 'set_cursor')
	$Floor.connect('mouse_exited', Cursor, 'set_cursor', [Cursor.Type.USE])
	$Floor.connect('clicked', self, '_on_floor_clicked')
	$Umbrella.connect('mouse_entered', self, 'set_in_umbrella', [true])
	$Umbrella.connect('mouse_exited', self, 'set_in_umbrella', [false])
	
	$HeightSlider.hide()
	set_process(false)
	
	appear()


func _process(delta: float) -> void:
	if $HeightSlider.visible:
		$HeightSlider.value += _direction
		
		if $HeightSlider.value >= $HeightSlider.max_value:
			_direction = -1
		elif $HeightSlider.value <= $HeightSlider.min_value:
			_direction = 1


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos set y get ░░░░
func set_in_umbrella(value: bool) -> void:
	_in_umbrella = value


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _on_floor_clicked() -> void:
	if _choosing_point:
		_choosing_point = false
		_choosing_height = true
		
		$HeightSlider.show()
		set_process(true)
	elif _choosing_height:
		set_process(false)
		
		yield(E.run([
			'Player: This is nuts...',
			'Player: But here we go!'
		]), 'completed')
		
#		E.goto_room('Falling')
