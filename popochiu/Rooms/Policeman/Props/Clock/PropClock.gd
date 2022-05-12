tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _process(delta: float) -> void:
	_format_time(OS.get_time().hour, OS.get_time().minute)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"Player: I don't want to mess this thing.",
		'Player: It has no buttons anyway.'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A digital clock.',
		'Player: Looks like it is on time.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _format_time(hh: int, mm: int) -> void:
	$H1.text = str(hh).pad_zeros(2)[0]
	$H2.text = str(hh).pad_zeros(2)[1]
	$M1.text = str(mm).pad_zeros(2)[0]
	$M2.text = str(mm).pad_zeros(2)[1]
