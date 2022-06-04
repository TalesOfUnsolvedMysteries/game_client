extends "res://popochiu/GraphicInterface/Popups/Painting/Painting.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#._ready()
	show()
	disconnect('gui_input', self, '_check_close')
	self.show_hidden(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
