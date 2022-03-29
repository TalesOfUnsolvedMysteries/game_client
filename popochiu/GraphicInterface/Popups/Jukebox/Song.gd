extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

export var song_file = 'test01'
export var hover_color = Color('e7de00')
export var regular_color = Color('ffffff')

func _ready():
	connect('mouse_entered', self, 'on_hover')
	connect('mouse_exited', self, 'on_exit')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	print('selected!')
	yield(E.run([A.play({
		'cue_name': song_file,
		'is_in_queue': true,
		'fade': true,
		'wait_audio_complete': true
	})]), 'completed')
	print('terminated!')


func on_look() -> void:
	pass

func on_hover():
	self.modulate = hover_color

func on_exit():
	self.modulate = regular_color


func on_item_used(item: InventoryItem) -> void:
	pass
