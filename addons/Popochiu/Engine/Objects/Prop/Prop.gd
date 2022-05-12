tool
class_name Prop, 'res://addons/Popochiu/icons/prop.png'
extends Clickable
# Elementos visuales para las habitaciones. Pueden tener interacción.
# Ej: las imágenes de fondo y primer plano, un objeto que se puede agarrar...

export var texture: Texture setget _set_texture
export var parallax_depth := 1.0 setget _set_parallax_depth
export var parallax_alignment := Vector2.ZERO

onready var _sprite: Sprite = $Sprite


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if not clickable:
		$CollisionPolygon2D.hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func on_interact() -> void:
	.on_interact()


func on_look() -> void:
	.on_look()


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _set_texture(value: Texture) -> void:
	texture = value
	$Sprite.texture = value


func _set_parallax_depth(value: float) -> void:
	parallax_depth = value
#	$ParallaxLayer.motion_scale = Vector2.ONE * value
	property_list_changed_notify()
