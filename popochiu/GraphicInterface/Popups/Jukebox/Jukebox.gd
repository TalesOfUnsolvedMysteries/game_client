extends PanelContainer

var last_played_songs = 'eee'

onready var secret: Secret = find_node('Secret')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$AnimationPlayer.play('RESET')
	
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	for song in find_node('Playlist').get_children():
		song.connect('played', self, '_on_song_played')
		song.connect('selected', self, '_show_disc')
	
	secret.connect('solved', self, '_on_solved')
	secret.connect('progress_calculated', self, '_on_progress_updated')
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	show()
	
	$AnimationPlayer.play('ShowList')


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
	
	$AnimationPlayer.stop()
	
	yield(E.run([
		E.runnable($AnimationPlayer, 'play', ['HideDisc'], 'animation_finished')
	]), 'completed')
	
	secret.solve(last_played_songs)

func _on_progress_updated(progress):
	var i = 0
	yield(E.run([E.wait(0.3)]), 'completed')
	for bulb in $CenterContainer/Bg.get_children():
		if i >= progress:
			(bulb.texture as AtlasTexture).region.position.x = 0
		else:
			(bulb.texture as AtlasTexture).region.position.x = 11.0
		i += 1
	if progress > 0:
		A.play({cue_name = 'sfx_jukebox_good_song',is_in_queue = false})
	else:
		A.play({cue_name = 'sfx_jukebox_bad_song',is_in_queue = false})
		A.play({cue_name = 'sfx_jukebox_bad_song',is_in_queue = false})

	yield(E.run([
		E.wait(0.8),
		E.runnable($AnimationPlayer, 'play', ['OnlyShowList'], 'animation_finished'),
	]), 'completed')


func _on_solved(solved):
	if solved:
		A.play({cue_name = 'sfx_jukebox_good_song',is_in_queue = false})
		for bulb in $CenterContainer/Bg.get_children():
			(bulb.texture as AtlasTexture).region.position.x = 11.0
		
		yield(E.run([
			E.runnable(
				$AnimationPlayer,
				'play',
				['HideList'],
				'animation_finished'
			),
			# TODO: play unlock sound
			'Player: Something was unlocked!'
		]), 'completed')
	else:
		secret.get_progress(last_played_songs)


func _show_disc() -> void:
	yield(E.run([
		E.runnable($AnimationPlayer, 'play', ['HideList'], 'animation_finished'),
		E.wait(0.5)	# cool to play an audio
	]), 'completed')
	$AnimationPlayer.play('ShowDisc')
