extends Sprite


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

func clone():
	spell_container.clone_spell(self, grid_pos)

func play_turn():
	#get the rune
	#test what the rune does
	#execute instructions
	pass
