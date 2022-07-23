extends Node2D

var _dungeon
var _decorated_rooms
# Called when the node enters the scene tree for the first time.
func _ready():
	$DungeonGenerator.connect('dungeon_changed', self, '_on_dungeon_updated')
	$DungeonGenerator.generate_dungeon()
	$Control/Generate.connect('button_down', self, '_on_generate_pressed')
	$Control/Generate2.connect('button_down', self, '_on_generate2_pressed')
	$Control/Generate3.connect('button_down', self, '_on_generate3_pressed')
	$Control/Generate4.connect('button_down', self, '_on_generate4_pressed')
	$Control/Merge.connect('button_down', self, '_on_merge_pressed')
	$Control/Tree.connect('button_down', self, '_on_tree_pressed')

func _on_dungeon_updated(dungeon):
	_dungeon = dungeon
	_decorated_rooms = $DungeonDecoratorBasic.decorate_dungeon_graph(dungeon)
	$DungeonDecoratorBasic.print_full_data_dungeon(dungeon, _decorated_rooms)

func _on_generate_pressed():
	var dungeon = $DungeonGenerator.generate_base_dungeon()
	_on_dungeon_updated(dungeon)

func _on_generate2_pressed():
	print('do nothing')
	pass

func _on_generate3_pressed():
	var dungeon = $DungeonGenerator.generate_base_dungeon()
	$DungeonGenerator.chance_merge(dungeon)
	_on_dungeon_updated(dungeon)


func _on_generate4_pressed():
	$DungeonGenerator.generate_dungeon()
	
func _on_merge_pressed():
	if not _dungeon: return
	$DungeonGenerator.random_merge_step(_dungeon)
	$DungeonDecoratorBasic.print_full_data_dungeon(_dungeon, _decorated_rooms)
	

func _on_tree_pressed():
	if not _dungeon: return
	$DungeonGenerator.reveal_tree(_dungeon)
	$DungeonDecoratorBasic.print_full_data_dungeon(_dungeon, _decorated_rooms)



