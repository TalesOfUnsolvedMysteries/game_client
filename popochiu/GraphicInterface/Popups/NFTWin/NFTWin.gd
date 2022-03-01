extends TextureButton
# Muestra a los jugadores que se ganaron un NFT. Se ven la imagen y el nombre
# del NFTrofeo.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

const NFT_PATH := 'res://popochiu/GraphicInterface/Popups/NFTWin/nfts/%s.png'

onready var nft: TextureRect = find_node('NFT')
onready var shadow: TextureRect = find_node('Shadow')
onready var label: Label = find_node('Label')

# Para meterle el efecto chimbita: https://youtu.be/DPDPI5zDeoM?t=385


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	hide()
	
	connect('pressed', self, '_close')
	G.connect('nft_won', self, '_open')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func open_sfx() -> void:
	A.play({
		cue_name = 'sfx_nft_won',
		is_in_queue = false
	})


func close_sfx() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _open(nft_data: Dictionary) -> void:
	show()
	
	var texture: Texture = load(NFT_PATH % nft_data.img)
	
	nft.texture = texture
	shadow.texture = texture
	label.text = nft_data.label
	
	$AnimationPlayer.play('Open')
	
#	yield($AnimationPlayer, 'animation_finished')
#	$AnimationPlayer.play('Glow')


func _close() -> void:
	$AnimationPlayer.play('Close')
	
	yield($AnimationPlayer, 'animation_finished')
	
	G.emit_signal('nft_shown')
	hide()
