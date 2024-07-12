extends Enemy

class_name DroneBot

@onready var tile_map: TileMap = get_node("../../TileMap")
@onready var player: Player = get_node("../../Player")
@export var bot_dmg: int = 1
@export var bot_speed: int = 400
@export var emp_duration: int = 5
var player_in_range: bool = false
var current_path: Array[Vector2i]

func _ready() -> void:
	is_moving = false
	speed = bot_speed
	damage = bot_dmg
	direction = Vector2.DOWN

func _on_body_entered(body) -> void:
	if body.name == "Player":
		enemyCollided.emit(body,self)
	emp_burst()
		
func _process(delta: float) -> void:
	if not is_chasing and not is_moving:
		if not current_path.is_empty():
			current_path.clear()
		return
	
	if current_path.is_empty():
		get_path_to_pos(player.position)
	else:
		set_direction()
		move_enemy(delta)
		
func move_enemy(delta: float) -> void:
	is_moving = true
	var target_pos: Vector2 = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, speed * delta)

	if global_position == target_pos:
		is_moving = false
		current_path.pop_front()

func get_path_to_pos(pos: Vector2) -> void:
	current_path = tile_map.astar.get_id_path(
		get_current_tile(),
		tile_map.local_to_map(pos)
	).slice(1)
	
func get_current_tile() -> Vector2i:
	return tile_map.local_to_map(global_position)
	
func set_direction() -> void:
	direction = current_path.front() - get_current_tile()
	
	if direction == Vector2.LEFT:
		rotation_degrees = 270
	elif direction == Vector2.RIGHT:
		rotation_degrees = 90
	elif direction == Vector2.UP:
		rotation_degrees = 0
	elif direction == Vector2.DOWN:
		rotation_degrees = 180

func emp_burst():
	if player_in_range:
		player.emp_hit(emp_duration)
		var tween: Tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 1)
		tween.tween_callback(queue_free)

func _on_player_detection_body_entered(body) -> void:
	if body.name == "Player":
		is_chasing = true
		player_in_range = true
		#emp_burst()

func _on_player_detection_body_exited(body) -> void:
	if body.name == "Player":
		is_chasing = false
		player_in_range = false
