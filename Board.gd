extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum CELL_TYPES { WALL, FLOOR, SPAWN }
var next_entity_id = 0

export(NodePath) var grid_path
var grid
export(Vector2) var start_position

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node(grid_path)
	#for child in get_children():
	#	set_cellv(world_to_map(child.position), child.type)
	set_cellv(start_position, CELL_TYPES.SPAWN)

func add_entity(position, id, type):
	match type:
		"spell":
			var spell = load("res://Spell.tscn").instance()
			spell.id = next_entity_id
			next_entity_id += 1
			spell.position = map_to_world(position) + cell_size / 2
			spell.type = CELL_TYPES.ACTOR
			spell.grid = grid
			add_child(spell)
			return spell.id

func move_entity(id, target):
	for child in get_children():
		if child.id == id:
			child.init_move(target)

func get_entity_pos(id):
	for child in get_children():
		if child.id == id:
			return child.position

func get_cell_pawn(cell, type = CELL_TYPES.ACTOR):
	for node in get_children():
		if node.type != type:
			continue
		if world_to_map(node.position) == cell:
			return(node)

func request_move(pawn, cell_target):
	var cell_start = world_to_map(pawn.position)

	var cell_tile_id = get_cellv(cell_target)
	var pawn_id = get_cellv(cell_start)
	match cell_tile_id:
		-1:
			set_cellv(cell_target, CELL_TYPES.ACTOR)
			set_cellv(cell_start, -1)
			return map_to_world(cell_target) + cell_size / 2
		CELL_TYPES.OBJECT, CELL_TYPES.ACTOR:
			var pawn_name = get_cell_pawn(cell_target, cell_tile_id).name
			print("Cell %s contains %s" % [cell_target, pawn_name])

func get_cell_type(position: Vector2):
	return get_cellv(position)

func damage_entity(position, dmg):
	var cell_tile_id = get_cellv(position)
	get_cell_pawn(position, cell_tile_id).take_damage(dmg)

func update_display():
	for node in get_children():
		node.update_display()

func get_world_position(pos):
	return map_to_world(pos) + position + cell_size / 2
