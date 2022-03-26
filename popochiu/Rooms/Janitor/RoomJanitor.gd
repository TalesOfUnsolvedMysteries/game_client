tool
extends PopochiuRoom

onready var notes: Panel = $CanvasLayer/JanitorNotes


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Overlay2D.hide()
	
	if not Globals.state.get('Janitor-JIGSAW_SOLVED'):
		$Overlay2D/Solved.hide()
		$Overlay2D/JigsawPuzzle.connect('solved', self, '_on_jigsaw_solved')
	else:
		$Overlay2D/JigsawPuzzle.queue_free()
		$Overlay2D/Solved.show()
	
	if OS.has_feature('editor'):
		Console.add_command('solve', self, '_on_jigsaw_solved').register()


func _exit_tree() -> void:
	if OS.has_feature('editor'):
		Console.remove_command('solve')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	A.play({cue_name = 'sfx_door_close',is_in_queue = false})


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_jigsaw() -> void:
	E.clicked.set_process_unhandled_input(false)
	E.clicked = null
	$Overlay2D.appear()


func show_notes() -> void:
	notes.appear()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _on_jigsaw_solved() -> void:
	Globals.set_state('Janitor-JIGSAW_SOLVED', true)
	$Overlay2D/JigsawPuzzle.queue_free()
	$Overlay2D/Solved.show()
	E.run([
		'Player: Wooooooo',
		'Player: There is no puzzle that can beat me!!!'
	])
