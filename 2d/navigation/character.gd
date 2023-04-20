extends Sprite

export(float) var character_speed = 400.0

onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
onready var navigation_path_debug_line: Line2D = $Line2D


func _ready():
	navigation_path_debug_line.set_as_toplevel(true)


func set_target_location(target_location: Vector2):
	navigation_agent.set_target_location(target_location)
	# Alternative way to get a full navigation path with Server API.
	var navigation_map: RID = get_world_2d().get_navigation_map()
	var start_position: Vector2 = get_global_transform().get_origin()
	var target_position: Vector2 = target_location
	var optimize: bool = true
	navigation_path_debug_line.points = Navigation2DServer.map_get_path(
			navigation_map,
			start_position,
			target_position,
			optimize
	)


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var next_position: Vector2 = navigation_agent.get_next_location()
	global_position = global_position.move_toward(next_position, delta * character_speed)