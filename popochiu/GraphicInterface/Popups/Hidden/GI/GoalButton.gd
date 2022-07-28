extends TextureButton

var desc := ''


func _ready() -> void:
	$Found.hide()


func done() -> void:
	$Found.show()
