extends Obstacle

class_name Missile

@export var missile_dir: Vector2i
@export var SPEED: int = 500
@export var missile_dmg: int = 2
@export var target_offset_min: int = 5
@export var target_offset_max: int = 10
@export var random_mode: bool = false
@onready var missile_target = $MissileTarget
@onready var tile_map: TileMap = get_node("../../TileMap")
var target_tile: Vector2i = Vector2i.ZERO

func set_random_target_pos() -> void:
	var current_tile: Vector2i = get_current_tile_pos()
	if direction == Vector2.RIGHT:
		rotation_degrees = 0
		target_tile = Vector2i(current_tile.x + randi_range(target_offset_min,target_offset_max),current_tile.y)
	elif direction == Vector2.LEFT:
		rotation_degrees = 180
		target_tile = Vector2i(current_tile.x + randi_range(-target_offset_min,-target_offset_max),current_tile.y)
	elif direction == Vector2.UP:
		rotation_degrees = 270
		target_tile = Vector2i(current_tile.x,current_tile.y + randi_range(-target_offset_min,-target_offset_max))
	elif direction == Vector2.DOWN:
		rotation_degrees = 90
		target_tile = Vector2i(current_tile.x,current_tile.y + randi_range(target_offset_min,target_offset_max))

func set_target_pos(pos: Vector2) -> void:
	target_tile = tile_map.local_to_map(pos)
	
	if direction == Vector2.RIGHT:
		rotation_degrees = 0
	elif direction == Vector2.LEFT:
		rotation_degrees = 180
	elif direction == Vector2.UP:
		rotation_degrees = 270
	elif direction == Vector2.DOWN:
		rotation_degrees = 90

func _ready() -> void:
	is_moving = true
	speed = SPEED
	damage = missile_dmg
	direction = missile_dir
	if random_mode:
		set_random_target_pos()

func _process(delta: float) -> void:
	if is_moving:
		position += speed * direction * delta
		missile_target.global_position = tile_map.map_to_local(target_tile)
		#if get_current_tile_pos() == target_tile:
			#explode()
		
func get_current_tile_pos() -> Vector2i:
	return tile_map.local_to_map(global_position)

func _on_body_entered(body) -> void:
	if body.name == "Player":
		is_colliding = true
		obstacleCollided.emit(body,self)
	explode()
	
func explode() -> void:
	is_moving = false
	print("Explosion!")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)

func _on_delete_timer_timeout() -> void:
	queue_free()
