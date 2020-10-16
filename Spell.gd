extends Sprite
class_name Spell

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum CELL_TYPES { ACTOR, OBJECT, OBSTACLE }

var type = CELL_TYPES.ACTOR
var id

var grid
var board

var grid_pos
var board_pos

var spell_container

#spell properties
var direction = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	spell_container = get_parent()

func clone(clone_position: Vector2):
	spell_container.clone_spell(self, clone_position)

func execute_action(instructions, action_cursor):
	if instructions[action_cursor] == "direction":
		action_cursor += 1
		direction = instructions[action_cursor]
		action_cursor += 1
	return action_cursor

func execute_runes():
	var alive = true
	var run = true
	while run:
		#get the rune
		var current_rune = grid.get_grid_cell(grid_pos) as Rune
		if current_rune == null:
			alive = false
			queue_free()
			break
		#get the rune's instructions
		var instructions = current_rune.get_actions()
		#execute instructions
		var action_cursor = 0
		while action_cursor < len(instructions):
			action_cursor = execute_action(instructions, action_cursor)
		
		print("Execute ", grid_pos)
		if current_rune.passthrough:
			#get next grid position
			var outputs = current_rune.get_outputs()
			var i = 1
			grid_pos = outputs[0]
			print(grid_pos)
			while i < len(outputs):
				clone(outputs[i])
				i += 1
		else:
			run = false
	return alive

func move():
	board_pos += direction
	position = board.get_world_position(board_pos)

func play_turn():
	if execute_runes():
		move()

func get_board_pos():
	return board_pos
