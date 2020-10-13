extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var rune_prefab
export (NodePath) var grid_path
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = get_node(grid_path)
	get_child(0).texture = (rune_prefab.instance()).get_texture()


var can_grab = false
var grabbed_offset = Vector2()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()
		if can_grab:
			print("grab new rune")
			var new_rune = rune_prefab.instance()
			new_rune.set('grid_path', grid_path)
			new_rune.set('grid', grid)
			new_rune.set('position', position)
			grid.add_child(new_rune)

func _process(delta):
	#if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
	#	position = get_global_mouse_position() + grabbed_offset
	pass
