extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal played

export var song_file = 'test01'
export var song_index = '0'
export var hover_color = Color('e7de00')
export var regular_color = Color('ffffff')
export var play_color = Color('66f80c')

var playing = false

func _ready():
	connect('mouse_entered', self, 'on_hover')
	connect('mouse_exited', self, 'on_exit')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	self.modulate = play_color
	playing = true
	yield(E.run([A.play({
		'cue_name': song_file,
		'is_in_queue': true,
		'wait_audio_complete': true
	})]), 'completed')
	self.modulate = regular_color
	emit_signal('played', song_index)
	playing = false


func on_look() -> void:
	pass

func on_hover():
	if playing: return
	self.modulate = hover_color

func on_exit():
	if playing: return
	self.modulate = regular_color


func on_item_used(item: InventoryItem) -> void:
	pass

