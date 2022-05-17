tool
extends "res://popochiu/Characters/Bug/CharacterBug.gd"

func _ready():
	load_appearance('440xxx')
	
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	.on_interact()


func on_look() -> void:
	.on_look()
