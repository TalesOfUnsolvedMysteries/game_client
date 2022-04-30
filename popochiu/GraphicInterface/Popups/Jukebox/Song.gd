extends Button

signal played
signal selected

export var song_file = 'test01'
export var song_index = '0'
export var hover_color = Color('e7de00')
export var regular_color = Color('ffffff')
export var play_color = Color('66f80c')

var playing = false


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	connect('mouse_entered', self, '_on_hover')
	connect('mouse_exited', self, '_on_exit')
	connect('pressed', Utils, 'invoke', [self, '_on_interact'])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _on_interact() -> void:
	playing = true
	emit_signal('selected')
	
	yield(E.run([
		'...',
		A.play({
		'cue_name': song_file,
		'is_in_queue': true,
		'wait_audio_complete': true
		})
	]), 'completed')
	
	modulate = regular_color
	set_pressed_no_signal(false)
	release_focus()
	emit_signal('played', song_index)
	
	playing = false


func _on_hover():
	if playing: return
	self.modulate = hover_color


func _on_exit():
	if playing: return
	self.modulate = regular_color
