extends Control

signal click_limit_reached
signal details_closed

const GOAL_BUTTON := preload('GI/GoalButton.tscn')

var _base_time := 1.0

onready var _goals_container: HBoxContainer = find_node('GoalsContainer')
onready var _click_meter: TextureProgress = find_node('ClickMeter')
onready var _tooltip: Label = find_node('Tooltip')
onready var _icon: TextureRect = $Details.find_node('Icon')
onready var _name: Label = $Details.find_node('Name')
onready var _clue: Label = $Details.find_node('Clue')
onready var _secret: Label = $Details.find_node('Secret')
onready var _btn_close: Button = $Details.find_node('BtnClose')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_btn_close.connect('pressed', self, 'hide_details')
	
	$Details.hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func add_goal(data: Dictionary) -> void:
	var goal: TextureButton = GOAL_BUTTON.instance()
	goal.name = data.obj
	goal.hint_tooltip = data.clu
	goal.texture_normal = data.ico
	goal.connect('pressed', self, '_goal_clicked', [goal])
	
	_goals_container.add_child(goal)


func count_try_click(is_object := false) -> void:
	$Tween.remove(_click_meter, 'value')
	
	if is_object:
		_click_meter.value += 10.0
	else:
		_click_meter.value += 3.0
	
	if _click_meter.value >= 100.0:
		emit_signal('click_limit_reached')
		return
	
	$Tween.interpolate_property(
		_click_meter, 'value',
		null, 0.0,
		_click_meter.value / _base_time, Tween.TRANS_LINEAR, Tween.EASE_OUT,
		0.5
	)
	$Tween.start()


func hide_tooltip() -> void:
	_tooltip.hide()


func check_clicked(obj_name: String) -> bool:
	var goal: TextureButton = _goals_container.get_node_or_null(obj_name)
	
	if goal:
		_click_meter.value = 0
		
		$Tween.remove(_click_meter, 'value')
		goal.done()
		
		return true
	
	count_try_click(true)
	return false


func show_details(data: Dictionary) -> void:
	_secret.hide()
	
	_icon.texture = data.ico
	_name.text = data.obj
	_clue.text = data.clu
	
	if data.has('sec'):
		_secret.text = data.sec
		_secret.show()
	
	$Details.show()


func hide_details() -> void:
	$Details.hide()
	emit_signal('details_closed')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _goal_clicked(goal: TextureButton) -> void:
	_tooltip.text = goal.hint_tooltip
	_tooltip.show()
