extends Enemy

class_name HeavyBot

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var level: Level = get_node("../../")
@onready var tile_map: TileMap = get_node("../../TileMap")
@onready var player: Player = get_node("../../Player")
@onready var missile: PackedScene = preload("res://scenes/projectiles/explosives/missile.tscn")
@export var bot_dmg: int = 1
@export var bot_speed: int = 250
@export var missile_cooldown_sec: float = 3

var current_path: Array[Vector2i]
var is_shooting: bool = false

func _ready() -> void:
	$CooldownTimer.wait_time = missile_cooldown_sec
	is_moving = false
	speed = bot_speed
	damage = bot_dmg
	direction = Vector2.DOWN

func _on_body_entered(body) -> void:
	if body.name == "Player":
		enemyCollided.emit(body,self)
	
func _process(delta: float) -> void:
	if not is_chasing and not is_moving or is_shooting:
		if not current_path.is_empty():
			current_path.clear()
		return
	
	if current_path.is_empty():
		get_path_to_pos(player.position)
	else:
		set_raycast_direction()
		check_raycast_collision()
		move_enemy(delta)

func move_enemy(delta: float) -> void:
	is_moving = true
	var target_pos: Vector2 = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, speed * delta)

	if global_position == target_pos:
		is_moving = false
		current_path.pop_front()
		
func set_raycast_direction() -> void:
	direction = current_path.front() - get_current_tile()
	
	if direction == Vector2.LEFT:
		ray_cast_2d.rotation_degrees = 90
	elif direction == Vector2.RIGHT:
		ray_cast_2d.rotation_degrees = 270
	elif direction == Vector2.UP:
		ray_cast_2d.rotation_degrees = 180
	elif direction == Vector2.DOWN:
		ray_cast_2d.rotation_degrees = 0
		
func check_raycast_collision() -> void:
	if not ray_cast_2d.is_colliding():
		return
		
	if can_shoot and not is_moving:
		$CooldownTimer.start()
		is_shooting = true
		can_shoot = false
		shoot_missile(direction)
		await get_tree().create_timer(0.5).timeout
		is_shooting = false

func get_path_to_pos(pos: Vector2) -> void:
	current_path = tile_map.astar.get_id_path(
		get_current_tile(),
		tile_map.local_to_map(pos)
	).slice(1)
	
func get_current_tile() -> Vector2i:
	return tile_map.local_to_map(global_position)
	
func shoot_missile(dir: Vector2) -> void:
	var missile_temp: Missile = missile.instantiate()
	missile_temp.missile_dir = dir
	missile_temp.position = global_position
	missile_temp.missile_dmg = 3
	get_node("../../Obstacles").add_child(missile_temp)
	missile_temp.obstacleCollided.connect(level._on_obstacle_collided)
	missile_temp.set_target_pos(player.global_position)
	
func _on_player_detection_body_entered(body) -> void:
	if body.name == "Player":
		is_chasing = true

func _on_player_detection_body_exited(body) -> void:
	if body.name == "Player":
		is_chasing = false
		is_shooting = false

func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
