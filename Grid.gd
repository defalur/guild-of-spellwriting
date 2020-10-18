extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tile_size = get_cell_size()
var grid = []
export var grid_size = Vector2(10,10)

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)
			set_cell(x, y, 0)

func check_bounds(grid_pos):
	return grid_pos.x >= 0 and grid_pos.x < grid_size.x \
		and grid_pos.y >= 0 and grid_pos.y < grid_size.y

func is_cell_of_type(pos=Vector2(), type=null):
	var grid_pos = world_to_map(pos)
	if check_bounds(grid_pos):
		return true if grid[grid_pos.x][grid_pos.y] == type else false

func is_cell_empty(pos=Vector2()):
	return is_cell_of_type(pos)

func get_snap(pos=Vector2()):
	return map_to_world(world_to_map(pos)) + (cell_size / 2)

func get_grid_position(pos=Vector2()):
	return world_to_map(pos)

func set_tile(pos: Vector2, rune):
	if check_bounds(pos):
		grid[pos.x][pos.y] = rune

func get_grid_cell(pos: Vector2):
	if check_bounds(pos):
		return grid[pos.x][pos.y]

func get_start_position():
	for child in get_children():
		if child.type == 'start':
			return child.grid_position

func is_valid_input(input, pos):
	var cell = get_grid_cell(pos)
	if cell == null:
		return false
	else:
		var inputs = cell.get_inputs()
		return (input in inputs)
