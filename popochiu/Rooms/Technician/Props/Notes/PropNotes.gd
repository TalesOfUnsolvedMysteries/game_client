tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Lets check this notes... because I am a chismoso'
	]), 'completed')
	
	G.show_documents({
		pages = [
			'From the previous technician\n\nTo make the elevator to work, its mainboard needs a battery and a memory card with the program that establishes its behavior (that is the floors it can access) ¿why they do something like this?',
			'The code to reset the mainboard after changing the battery is:\n\nWELCOME 85649\nCAR 87459',
			'To change the functionality of the elevator use the PC in the lobby'
		]
	})


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
