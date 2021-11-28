extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	# TODO: Que se agregue la batería al inventario si está descargada.
	hide()
