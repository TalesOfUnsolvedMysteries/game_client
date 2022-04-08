tool
extends Prop

export var balance_config = [2.0, 0.5, 0.8, 0.7]
export var weight_index = 0
export var offset_balance = 0
var balance = 0

func _ready():
	Globals.connect('shelf_weights_updated', self, 'evaluate')
	evaluate()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	$Vase.on_interact()


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	$Vase.on_item_used(item)

func evaluate():
	var weights = Globals.state.get('Penthouse_WEIGHTS_ON_Shelfs')
	balance = weights[0]*balance_config[0] + weights[1]*balance_config[1] + weights[2]*balance_config[2] + weights[3]*balance_config[3]
	var rounded_balance = round(balance * 5)
	print('raw balance: ', balance)
	print('this balance: ', rounded_balance)
	rounded_balance = clamp(rounded_balance, -40, 20 - offset_balance) + offset_balance
	#$ShelfBody.position.y = -18 + rounded_balance
	#$ShelfBody.region_rect.size.y = 26 - rounded_balance
	#$Vase.position.y = -24 + rounded_balance
	$Tween.interpolate_property($ShelfBody, "position:y", $ShelfBody.position.y, -18 + rounded_balance, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ShelfBody, "region_rect:size:y", $ShelfBody.region_rect.size.y, 26 - rounded_balance, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Vase, "position:y", $Vase.position.y, -24 + rounded_balance, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
