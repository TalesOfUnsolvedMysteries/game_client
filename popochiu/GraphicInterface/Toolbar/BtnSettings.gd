extends ToolbarButton

export var settings_path: NodePath = ''

var _settings: Control = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if get_node_or_null(settings_path):
		_settings = get_node(settings_path)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_pressed() -> void:
	if is_instance_valid(_settings):
		_settings.appear()
