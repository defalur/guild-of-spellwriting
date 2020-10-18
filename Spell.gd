extends Sprite
class_name Spell

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum CELL_TYPES { WALL, FLOOR, SPAWN }

var id

var grid
var board

var grid_pos
var board_pos

var spell_container

#spell properties
var direction = Vector2()
var triggers = []
var valid_cond = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spell_container = get_parent()

func clone(clone_position: Vector2):
	return spell_container.clone_spell(self, clone_position, direction)

func check_triggers():
	var result = []
	if board.get_cell_type(board_pos + direction) == CELL_TYPES.WALL:
		result.append('collision')
	triggers = result

func get_dir(cur_dir: Vector2, new_dir: Vector2):
	if cur_dir == Vector2(0, 0) or new_dir == Vector2(0, 0):
		return new_dir
	else:
		var angle_up_new = Vector2(0, -1).angle_to(new_dir)
		return cur_dir.rotated(angle_up_new)

func execute_action(instructions, action_cursor):
	if instructions[action_cursor] == "direction":
		action_cursor += 1
		direction = get_dir(direction, instructions[action_cursor])
		action_cursor += 1
		print("Dir: ", direction)
	elif instructions[action_cursor] == "condition":
		action_cursor += 1
		var trigger = instructions[action_cursor]
		action_cursor += 1
		valid_cond = (trigger in triggers)
		print("Trigger: ", valid_cond)
	return action_cursor

func execute_runes():
	var alive = true
	var run = true
	check_triggers()
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
		if current_rune.passthrough or (current_rune.condition and valid_cond):
			#get next grid position
			var outputs = current_rune.get_outputs()
			var i = 1
			if grid.is_valid_input(grid_pos, outputs[0]):
				grid_pos = outputs[0]
			else:
				queue_free()
				run = false
				alive = false
			while i < len(outputs):
				if grid.is_valid_input(grid_pos, outputs[i]):
					clone(outputs[i]).play_turn()
				i += 1
		else:
			run = false
	check_triggers()
	return alive

func move():
	if 'collision' in triggers:
		queue_free()
		return
	board_pos += direction
	position = board.get_world_position(board_pos)

func play_turn():
	if execute_runes():
		move()

func get_board_pos():
	return board_pos
