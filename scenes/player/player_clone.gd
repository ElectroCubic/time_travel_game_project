extends CharacterBody2D

class_name PlayerClone

var direction: Vector2
var is_moving: bool = false
var is_controlled: bool = false
var is_recording: bool = false
var recording: Array[Vector2]
var type: CloneType
var num_of_moves: int = 0

@export var move_time: float
@onready var player = get_node("../../Player") as Player
@onready var tile_map = get_node("../../TileMap") as TileMap

enum CloneType {
	CHRONO_LOOP,
	CHRONO_PHANTOM,
	CHRONO_BOMB
}

func _ready():
	if type == CloneType.CHRONO_LOOP:
		$AnimatedSprite2D.play("Chrono_Loop_Idle")
	elif type == CloneType.CHRONO_PHANTOM:
		$AnimatedSprite2D.play("Chrono_Phantom_Idle")
	elif type == CloneType.CHRONO_BOMB:
		$AnimatedSprite2D.play("Chrono_Bomb_Idle")
		
func _unhandled_key_input(_event):
	if is_moving == false and is_controlled:
		player_input()
		move_clone(direction)
		if is_recording:
			record_movement(direction)
		
func player_input():
	if Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("Up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("Down"):
		direction = Vector2.DOWN
		
	if num_of_moves > 0:
		num_of_moves -= 1
		check_moves()

func move_clone(dir: Vector2i):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var target_pos: Vector2 = tile_map.map_to_local(target_tile)

	is_moving = true
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, move_time).set_trans(Tween.TRANS_SINE)
	await tween.finished
	is_moving = false

func record_movement(dir):
	recording.append(dir)
	#print(recording)

func replay_movements():
	for dir in recording:
		await move_clone(dir)

func check_moves():
	if num_of_moves == 0:
		is_controlled = false
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 1).set_delay(0.4)
		await tween.finished
		print("BOOM!")
		player.is_controlled = true
		queue_free()
