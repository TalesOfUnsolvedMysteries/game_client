extends Node
# Clase de uso transversal para todos los objetos del proyecto. Aquí se puede
# guardar información que se usará en varias habitaciones, o cosas relacionadas
# con el estado del juego.

enum Bodies {
	BEETLE,
	LADYBUG,
	BEE
}

var main_mx_play = false

var bug_name := ''
var state := {}
