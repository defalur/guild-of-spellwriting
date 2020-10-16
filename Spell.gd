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

# Called when the node enters the scene tree for the first time.
func _ready():
	spell_container = get_parent()

func clone(clone_position: Vector2):
	spell_container.clone_spell(self, clone_position)

func play_turn():
	var run = true
	while run:
		#get the rune
		var current_rune = grid.get_grid_cell(grid_pos)
		if current_rune == null:
			break
		#test what the rune does
		
		#execute instructions
		print("Execute ", grid_pos)
		if current_rune.passthrough:
			#get next grid position
			var outputs = current_rune.get_outputs()
			var i = 1
			while i < len(outputs):
				clone(outputs[i])
				i += 1
			grid_pos = outputs[0]
		else:
			run = false
	print("Stop")

func get_board_pos():
	return board_pos
