extends Obstacle

class_name WoodenBox

@export var move_time: float = 0.2
@onready var player = get_node("../../Player") as Player
@onready var tile_map = get_node("../../TileMap") as TileMap
@onready var box_front := $Box_Front
@onready var box_back := $Box_Back
@onready var box_right := $Box_Right
@onready var box_left := $Box_Left
var target_pos: Vector2

func _ready() -> void:
	toggle_active()

func toggle_active() -> void:
	is_active = !is_active
	set_physics_process(is_active)
	box_front.enabled = is_active
	box_back.enabled = is_active
	box_left.enabled = is_active
	box_right.enabled = is_active

func _physics_process(_delta) -> void:
	check_box_collision()

func check_box_collision() -> void:
	var left_collider = box_left.get_collider()
	var right_collider = box_right.get_collider()
	var up_collider = box_back.get_collider()
	var down_collider = box_front.get_collider()
	
	if left_collider and left_collider.has_method("cant_push") and right_collider:
		left_collider.cant_push(Vector2i.RIGHT)
	
	if right_collider and right_collider.has_method("cant_push") and left_collider:
		right_collider.cant_push(Vector2i.LEFT)
	
	if up_collider and up_collider.has_method("cant_push") and down_collider:
		up_collider.cant_push(Vector2i.DOWN)
	
	if down_collider and down_collider.has_method("cant_push") and up_collider:
		down_collider.cant_push(Vector2i.UP)

func move_box(dir: Vector2i) -> void:
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

func _on_body_entered(body) -> void:
	if not body is TileMap:
		move_box(body.direction)

func _on_player_near_body_entered(_body) -> void:
	toggle_active()

func _on_player_near_body_exited(body) -> void:
	toggle_active()
	if not body is TileMap:
		body.cant_push(Vector2.ZERO)
