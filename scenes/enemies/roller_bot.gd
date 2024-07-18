extends Enemy

class_name RollerBot

@onready var ray_cast_2d = $RayCast2D
@onready var player: Player = get_node("../../Player")

@export var bot_dmg: int = 3
@export var bot_speed: int = 600
@export var offset: int = 0
@export var forward: bool = true
var path: Path2D
var path_follow: PathFollow2D

func _ready() -> void:
	is_moving = false
	speed = bot_speed
	damage = bot_dmg
	path = get_children().back() 	# Gives Path2D Node
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.progress = offset

func _physics_process(delta: float) -> void:
	set_ray_dir()
	check_player_presence()
	move_enemy(delta)
	
func set_ray_dir():
	if forward:
		ray_cast_2d.rotation_degrees = path_follow.rotation_degrees
	else:
		ray_cast_2d.rotation_degrees = path_follow.rotation_degrees - 180

	ray_cast_2d.force_update_transform()
	ray_cast_2d.force_raycast_update()

func move_enemy(delta: float) -> void:
	var dir = 1 if forward else -1
	path_follow.progress += bot_speed * dir * delta
	position = path_follow.position

func check_player_presence() -> void:
	var player_dir := global_position.direction_to(player.position)
	
	if player_dir.normalized() != Vector2.ZERO:
		if ray_cast_2d.is_colliding():
			forward = !forward

func _on_body_entered(body) -> void:
	if body.name == "Player":
		print("Oof")
		#queue_free()
	enemyCollided.emit(body,self)
