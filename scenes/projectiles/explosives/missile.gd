extends Obstacle

class_name Missile

@export var missile_dir: Vector2i = Vector2i.RIGHT
@export var SPEED: int = 500
@export var missile_dmg: int = 2
@export var target_offset_min: int = 5
@export var target_offset_max: int = 10
@onready var missile_target = $MissileTarget
@onready var tile_map: TileMap = get_node("../../TileMap")
var random_target_tile: Vector2i = Vector2i.ZERO

func set_random_target_pos():
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	
	if direction == Vector2.RIGHT:
		rotation_degrees = 0
		random_target_tile = Vector2i(current_tile.x + randi_range(target_offset_min,target_offset_max),current_tile.y)
	elif direction == Vector2.LEFT:
		rotation_degrees = 180
		random_target_tile = Vector2i(current_tile.x + randi_range(-target_offset_min,-target_offset_max),current_tile.y)
	elif direction == Vector2.UP:
		rotation_degrees = 270
		random_target_tile = Vector2i(current_tile.x,current_tile.y + randi_range(-target_offset_min,-target_offset_max))
	elif direction == Vector2.DOWN:
		rotation_degrees = 90
		random_target_tile = Vector2i(current_tile.x,current_tile.y + randi_range(target_offset_min,target_offset_max))

func _ready():
	is_moving = true
	speed = SPEED
	damage = missile_dmg
	direction = missile_dir
	set_random_target_pos()

func _process(delta):
	if is_moving:
		position += speed * direction * delta
		missile_target.global_position = tile_map.map_to_local(random_target_tile)
		get_current_tile_pos()

func get_current_tile_pos():
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	
	if current_tile == random_target_tile:
		explode()

func _on_body_entered(body):
	if body.name == "Player":
		is_colliding = true
		obstacleCollided.emit(body,self)
	explode()
	
func explode():
	is_moving = false
	print("Explosion!")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.8)
	tween.tween_callback(queue_free)
	await tween.finished
