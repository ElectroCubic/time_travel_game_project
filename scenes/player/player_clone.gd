extends CharacterBody2D

class_name PlayerClone

var direction: Vector2i
var is_moving: bool = false
var is_controlled: bool = false
var is_recording: bool = false
var recording: Array[Vector2i]
var type: CloneType
var num_of_moves: int = 0
var push_dirs: Array[bool] = [true,true,true,true]

@export var chrono_phantom_moves: int = 5
@export var chrono_bomb_moves: int = 5
@export var move_time: float = 1.0
@onready var player = get_node("../../Player") as Player
@onready var tile_map = get_node("../../TileMap") as TileMap

enum CloneType {
	CHRONO_LOOP,
	CHRONO_PHANTOM,
	CHRONO_BOMB
}

func _ready() -> void:
	if type == CloneType.CHRONO_LOOP:
		$AnimatedSprite2D.play("Chrono_Loop_Idle")
	elif type == CloneType.CHRONO_PHANTOM:
		num_of_moves = chrono_phantom_moves
		player.connect("input_pressed", _on_player_input_pressed)
		$AnimatedSprite2D.play("Chrono_Phantom_Idle")
	elif type == CloneType.CHRONO_BOMB:
		num_of_moves = chrono_bomb_moves
		$AnimatedSprite2D.play("Chrono_Bomb_Idle")

func _unhandled_key_input(_event) -> void:
	if is_controlled and not is_moving:
		player_input()

func cant_push(dir: Vector2i):
	push_dirs[0] = false if dir == Vector2i.LEFT else true
	push_dirs[1] = false if dir == Vector2i.RIGHT else true
	push_dirs[2] = false if dir == Vector2i.UP else true
	push_dirs[3] = false if dir == Vector2i.DOWN else true

func player_input() -> void:
	if Input.is_action_pressed("Left") and push_dirs[0]:
		move_clone(Vector2i.LEFT)
	elif Input.is_action_pressed("Right") and push_dirs[1]:
		move_clone(Vector2i.RIGHT)
	elif Input.is_action_pressed("Up") and push_dirs[2]:
		move_clone(Vector2i.UP)
	elif Input.is_action_pressed("Down") and push_dirs[3]:
		move_clone(Vector2i.DOWN)

func check_moves() -> void:
	if num_of_moves > 0 and type == CloneType.CHRONO_BOMB:
		num_of_moves -= 1
		if num_of_moves == 0:
			self_destruct()

func move_clone(dir: Vector2i) -> void:
	direction = dir
	if is_recording:
		record_movement(dir)
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var tile_data := tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		var target_pos: Vector2 = tile_map.map_to_local(target_tile)
		is_moving = true
		check_moves()
		var tween: Tween = create_tween()
		tween.tween_property(self, "global_position", target_pos, move_time).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		is_moving = false

func record_movement(dir: Vector2i) -> void:
	recording.append(dir)
	#print(recording)

func replay_movements() -> void:
	await get_tree().create_timer(0.5).timeout
	for dir in recording:
		await move_clone(dir)
		
func _on_player_input_pressed() -> void:
	if num_of_moves > 0:
		num_of_moves -= 1
		print(num_of_moves)
		if num_of_moves == 0:
			disappear()

func disappear() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(queue_free)
	
func self_destruct() -> void:
	is_controlled = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1).set_delay(0.4)
	await tween.finished
	print("BOOM!")
	player.is_controlled = true
	queue_free()
