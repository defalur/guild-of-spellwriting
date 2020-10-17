extends KinematicBody2D
class_name Rune

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

export var type: String

# action parameters
export(bool) var passthrough = true # wether the spell should immediately jump to the next rune
export(bool) var set_direction = false
export(int, FLAGS, "up", "right", "down", "left") var direction_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(grid_path)
	if grid == null:
		grid = get_node(grid_path)
	else:
		grabbed = true

func get_texture():
	return get_node("RuneSprite").texture

var can_grab = false
var grabbed_offset = Vector2()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			can_grab = event.pressed
			grabbed_offset = position - get_global_mouse_position()
			if not can_grab and grid.is_cell_empty(position + grabbed_offset):
				position = grid.get_snap(position + grabbed_offset)
				if not grabbed:
					grid.set_tile(grid_position, null)
				grid_position = grid.get_grid_position(position)
				grabbed = false
				grid.set_tile(grid_position, self)
			elif not can_grab:
				var grid_pos = grid.get_grid_position(position)
				if not grid.check_bounds(grid_pos):
					print("Free")
					queue_free()
		if event.pressed:
			print(can_grab)
			if event.button_index == BUTTON_WHEEL_DOWN:
				rotate(-1)
			elif event.button_index == BUTTON_WHEEL_UP:
				rotate(1)
			elif event.button_index == BUTTON_RIGHT and (can_grab or grabbed):
				rotate(1)
			elif event.button_index == BUTTON_RIGHT:
				rotate_effects(1)
				pass

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab or grabbed:
		position = get_global_mouse_position() + grabbed_offset

func test_flag(flags: int, direction: int):
	var mask = 1 << direction
	return mask & flags != 0

func get_opposite_direction(direction):
	return (direction + 2) % 4

func get_direction_vectors_from_flag(flag):
	var result = []
	if test_flag(flag, Direction.UP):
		result.append(Vector2(0, -1))
	if test_flag(flag, Direction.RIGHT):
		result.append(Vector2(1, 0))
	if test_flag(flag, Direction.DOWN):
		result.append(Vector2(0, 1))
	if test_flag(flag, Direction.LEFT):
		result.append(Vector2(-1, 0))
	return result

func get_outputs():
	var result = get_direction_vectors_from_flag(outputs)
	for i in range(len(result)):
		result[i] += grid_position
	print("Out: ", result)
	return result

func get_actions():
	var result = []
	if set_direction:
		var direction_list = get_direction_vectors_from_flag(direction_value)
		var result_direction = Vector2()
		for d in direction_list:
			result_direction += d
		result.append("direction")
		result.append(result_direction)
	return result

func rotate_flags(flags, delta):
	if delta > 0:
		flags = ((flags << delta) | (flags >> 4 - delta)) & 15
	elif delta < 0:
		delta = abs(delta)
		flags = ((flags >> delta) | (flags << 4 - delta)) & 15
	return flags

func rotate(delta):
	print(get_direction_vectors_from_flag(direction_value))
	inputs = rotate_flags(inputs, delta)
	outputs = rotate_flags(outputs, delta)
	print(get_direction_vectors_from_flag(direction_value))
	get_node("BackSprite").rotate((PI / 2) * delta)

func rotate_effects(delta):
	print(get_direction_vectors_from_flag(direction_value))
	direction_value = rotate_flags(direction_value, delta)
	print(get_direction_vectors_from_flag(direction_value))
	get_node("RuneSprite").rotate((PI / 2) * delta)
