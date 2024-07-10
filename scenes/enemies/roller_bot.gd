extends Enemy

class_name RollerBot

@onready var player: Player = get_node("../../Player")
@export var bot_dmg: int = 1
@export var bot_speed: int = 600
@export var mark_points_array: Array[Marker2D]

var clock_wise_dir: bool = true
var target_pos: Vector2
var current_index: int = 0
var no_of_points: int = 0

func _ready():
	is_moving = false
	speed = bot_speed
	damage = bot_dmg
	direction = Vector2.DOWN
	no_of_points = mark_points_array.size()
	update_next_target_pos()

func _process(delta):
	if not is_moving:
		return
	
	check_player_presence()
	move_enemy(delta)

func move_enemy(delta) -> void:
	global_position = global_position.move_toward(target_pos, speed * delta)
	
	if global_position == target_pos:
		is_moving = false
		update_next_target_pos()

func update_next_target_pos():
	is_moving = true
	if clock_wise_dir:
		if current_index < no_of_points:
			target_pos = mark_points_array[current_index].position
			current_index += 1
		else:
			current_index = 0
	else:
		if current_index >= 0 and current_index < no_of_points:
			target_pos = mark_points_array[current_index].position
			current_index -= 1
		else:
			current_index = no_of_points - 1
			
func get_direction_to(pos: Vector2) -> Vector2:
	return global_position.direction_to(pos)

func check_player_presence():
	var relative_side = get_direction_to(player.position)
	var target_side = get_direction_to(target_pos)
	
	if (relative_side == Vector2.LEFT or
		relative_side == Vector2.RIGHT or
		relative_side == Vector2.UP or
		relative_side == Vector2.DOWN) and relative_side != target_side:
		
		clock_wise_dir = !clock_wise_dir
		if clock_wise_dir:
			current_index += 1
		else:
			current_index -= 1
		update_next_target_pos()

func _on_body_entered(body):
	if body.name == "Player":
		enemyCollided.emit(body,self)
