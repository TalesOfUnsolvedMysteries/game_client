extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	hide()
	E.run([
		'Player: I need to find a way to charge this battery.',
		I.add_item('MotherboardBattery'),
		# TODO: ¿Reproducir un sonido?
	])
