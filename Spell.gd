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

# Called when the node enters the scene tree for the first time.
func _ready():
	board.request_position()

func clone():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
