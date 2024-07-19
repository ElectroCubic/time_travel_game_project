@tool
extends Obstacle

class_name StaticLaser

@export_enum('Left','Right','Up','Down') var orientation: String = 'Right':
	set(value):
		if value != null and value != "":
			orientation = value
			set_orientation(value)
@export var laser_dmg: int = 2
@export var laser_active: bool = true:
	set(value):
		laser_active = value
		set_process(laser_active)

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $RayCast2D/Line2D
var collisionPos: Vector2 = Vector2.ZERO

func _ready() -> void:
	damage = laser_dmg
	is_active = laser_active
	can_move = false
	set_process(is_active)
	if is_active:
		line_2d.add_point(ray_cast_2d.position)
		line_2d.add_point(ray_cast_2d.target_position)

func _process(_delta) -> void:
	if not Engine.is_editor_hint():
		if is_active:
			check_collision()
			update_laser_collision()

func set_orientation(dir) -> void:
	if dir == 'Left':
		rotation_degrees = 180
	elif dir == 'Right':
		rotation_degrees = 0
	elif dir == 'Up':
		rotation_degrees = 270
	elif dir == 'Down':
		rotation_degrees = 90

func check_collision() -> void:
	if ray_cast_2d.is_colliding():
		var collider := ray_cast_2d.get_collider()
		collisionPos = ray_cast_2d.get_collision_point()
		is_colliding = true
		obstacleCollided.emit(collider, self)
	else:
		is_colliding = false

func update_laser_collision() -> void:
	if is_colliding:
		match orientation:
			'Left':
				line_2d.add_point(Vector2(ray_cast_2d.global_position.x - collisionPos.x,0))
			'Right':
				line_2d.add_point(Vector2(collisionPos.x - ray_cast_2d.global_position.x,0))
			'Up':
				line_2d.add_point(Vector2(ray_cast_2d.global_position.y - collisionPos.y,0))
			'Down':
				line_2d.add_point(Vector2(collisionPos.y - ray_cast_2d.global_position.y,0))
	else:
		line_2d.add_point(ray_cast_2d.target_position)

	line_2d.remove_point(1)
