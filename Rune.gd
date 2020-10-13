extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum Direction {UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3}

export (NodePath) var grid_path
var grid
var grabbed = false
var grid_position = Vector2()
export(int, FLAGS, "up", "right", "down", "left") var inputs = 0
export(int, FLAGS, "up", "right", "down", "left") var outputs = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(grid_path)
	if grid == null:
		grid = get_node(grid_path)
	else:
		grabbed = true

func get_texture():
	return get_child(1).texture

var can_grab = false
var grabbed_offset = Vector2()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()
		if not can_grab and grid.is_cell_empty(position + grabbed_offset):
			position = grid.get_snap(position + grabbed_offset)
			if not grabbed:
				grid.set_tile(grid_position, null)
			grid_position = grid.get_grid_position(position)
			grabbed = false
			grid.set_tile(grid_position, self)

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab or grabbed:
		position = get_global_mouse_position() + grabbed_offset

func test_flag(flags: int, direction):
	var mask = 1 << direction
	return mask & flags != 0

func get_opposite_direction(direction):
	return (direction + 2) % 4
