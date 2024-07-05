extends Obstacle

class_name StaticLaser

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var line_2d = $RayCast2D/Line2D
var collisionPos: Vector2 = Vector2.ZERO

enum Laser_Orientation {
	LEFT,
	RIGHT,
	UP,
	DOWN
}
@export var orientation: Laser_Orientation = Laser_Orientation.LEFT
@export var laser_dmg: int = 2
@export var laser_active: bool:
	set(value):
		laser_active = value
		set_process(laser_active)

func _ready():
	damage = laser_dmg
	is_active = laser_active
	can_move = false
	set_process(is_active)
	if is_active:
		line_2d.add_point(ray_cast_2d.position)
		line_2d.add_point(ray_cast_2d.target_position)
	
func _process(_delta):
	if is_active:
		check_collision()
		update_laser_collision()
	
func check_collision():
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		collisionPos = ray_cast_2d.get_collision_point()
		is_colliding = true
		obstacleCollided.emit(collider, self)
	else:
		is_colliding = false

func update_laser_collision() -> void:
	if is_colliding:
		match orientation:
			Laser_Orientation.LEFT:
				line_2d.add_point(Vector2(ray_cast_2d.global_position.x - collisionPos.x,0))
			Laser_Orientation.RIGHT:
				line_2d.add_point(Vector2(collisionPos.x - ray_cast_2d.global_position.x,0))
			Laser_Orientation.UP:
				line_2d.add_point(Vector2(ray_cast_2d.global_position.y - collisionPos.y,0))
			Laser_Orientation.DOWN:
				line_2d.add_point(Vector2(collisionPos.y - ray_cast_2d.global_position.y,0))
	else:
		line_2d.add_point(ray_cast_2d.target_position)

	line_2d.remove_point(1)
