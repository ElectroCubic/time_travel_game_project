extends Enemy

class_name HeavyBot

@onready var tile_map: TileMap = get_node("../../TileMap")
@onready var player: Player = get_node("../../Player")
@export var bot_dmg: int = 1
@export var bot_speed: int = 1

var current_path: Array[Vector2i]

func _ready():
	speed = bot_speed
	damage = bot_dmg
	direction = Vector2.DOWN

func _on_body_entered(body):
	if body.name == "Player":
		enemy_collided.emit(body,self)

func _process(_delta):
	if not is_chasing:
		return
	
	if current_path.is_empty():
		get_path_to_pos(player.position)
	else:
		move_enemy()

func move_enemy() -> void:
	var target_pos = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, speed)
	
	if global_position == target_pos:
		current_path.pop_front()

func get_path_to_pos(pos):
	current_path = tile_map.astar.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(pos)
	).slice(1)
	
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		is_chasing = true

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		is_chasing = false
