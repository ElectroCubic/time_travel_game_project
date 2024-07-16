extends Obstacle

class_name WoodenBox

@export var move_time: float = 0.25
@onready var player = get_node("../../Player") as Player
@onready var tile_map = get_node("../../TileMap") as TileMap
@onready var box_front = $Box_Front
@onready var box_back = $Box_Back
@onready var box_right = $Box_Right
@onready var box_left = $Box_Left
var target_pos: Vector2

func _ready():
	set_physics_process(false)

func _physics_process(_delta):
	check_box_collision()

func check_box_collision():
	var left_collider = box_left.get_collider()
	var right_collider = box_right.get_collider()
	var up_collider = box_back.get_collider()
	var down_collider = box_front.get_collider()
	
	if left_collider is Player and right_collider != null:
		left_collider.cant_push(Vector2i.RIGHT)
	
	elif right_collider is Player and left_collider != null:
		right_collider.cant_push(Vector2i.LEFT)
	
	elif up_collider is Player and down_collider != null:
		up_collider.cant_push(Vector2i.DOWN)
	
	elif down_collider is Player and up_collider != null:
		down_collider.cant_push(Vector2i.UP)

func move_box(dir):
	if is_moving:
		return
		
	target_pos = get_target_pos(dir)
		
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, move_time)
	is_moving = true
	await tween.finished
	is_moving = false

func get_tile_at(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)
	
func can_move_towards(tile: Vector2i) -> bool:
	var tile_data := tile_map.get_cell_tile_data(0,tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		return true
	else:
		return false

func get_target_pos(dir: Vector2i) -> Vector2:
	var current_tile: Vector2i = get_tile_at(global_position)
	var target_tile: Vector2i = current_tile + dir
	return tile_map.map_to_local(target_tile)

func _on_body_entered(body):
	if not body is TileMap:
		move_box(body.direction)

func _on_player_near_body_entered(body):
	if not body is TileMap and not body is WoodenBox:
		set_physics_process(true)

func _on_player_near_body_exited(body):
	if not body is TileMap:
		set_physics_process(false)
		body.cant_push(Vector2.ZERO)
