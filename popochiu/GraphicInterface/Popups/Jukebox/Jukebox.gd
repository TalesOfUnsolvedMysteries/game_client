extends PanelContainer

var last_played_songs = 'eee'
onready var secret: Secret = find_node('Secret')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	#hide()
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	var _songs = find_node('Playlist').get_children()
	for song in _songs:
		song.connect('played', self, '_on_song_played')
		song.connect('selected', self, '_show_disc')
	secret.connect('solved', self, '_on_solved')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	show()


func disappear() -> void:
	Utils.invoke(self, '_close')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()


func _close():
	Cursor.set_cursor()
	G.show_info()
	hide()
	

func _on_song_played(song_index):
	last_played_songs = '%s%s' % [song_index, last_played_songs]
	last_played_songs = last_played_songs.substr(0, 3)
	secret.solve(last_played_songs)

func _on_solved(solved):
	if solved:
		print('secret solved!')
		yield(E.run(['Player: something was unlocked!']), 'completed')
		# play unlock sound


func _show_disc() -> void:
	$AnimationPlayer.play('ShowDisc')
