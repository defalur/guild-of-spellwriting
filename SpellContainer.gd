extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var spell_prefab

export(NodePath) var board_path
var board

export(NodePath) var grid_path
var grid

var next_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node(grid_path)
	board = get_node(board_path)

func clone_spell(spell, grid_pos):
	var new_spell = spell_prefab.instance()
	new_spell.board = board
	new_spell.grid = grid
	new_spell.position = spell.position
	new_spell.board_pos = (spell as Spell).get_board_pos()
	new_spell.id = next_id
	next_id += 1
	new_spell.grid_pos = grid_pos
	add_child(new_spell)

func create_spell():
	var grid_pos = grid.get_start_position()
	var new_spell = spell_prefab.instance()
	new_spell.board = board
	new_spell.grid = grid
	new_spell.grid_pos = grid_pos
	new_spell.board_pos = board.start_position
	new_spell.position = board.map_to_world(new_spell.board_pos)
	new_spell.id = next_id
	next_id += 1
	add_child(new_spell)

func launch_spell():
	create_spell()
	for i in range(10):
		play_turn()

func play_turn():
	for spell in get_children():
		spell.play_turn()
