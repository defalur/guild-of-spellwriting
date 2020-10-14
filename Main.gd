extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var board
var grid
var spell_container

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node("Grid")
	board = get_node("Board")
	spell_container = get_node("SpellContainer")

func start_spell():
	spell_container.create_spell()

func _input(event):
	if event.is_action_pressed("ui_right"):
		spell_container.play_turn()
