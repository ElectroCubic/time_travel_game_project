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
		player.connect("input_pressed", _on_player_input_pressed)
		$AnimatedSprite2D.play("Chrono_Phantom_Idle")
	elif type == CloneType.CHRONO_BOMB:
		$AnimatedSprite2D.play("Chrono_Bomb_Idle")

func _unhandled_key_input(_event):
	if is_controlled and not is_moving:
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

func check_moves():
	if num_of_moves > 0 and type == CloneType.CHRONO_BOMB:
		num_of_moves -= 1
		if num_of_moves == 0:
			self_destruct()

func move_clone(dir: Vector2i):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var tile_data = tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		var target_pos: Vector2 = tile_map.map_to_local(target_tile)
		is_moving = true
		check_moves()
		var tween = create_tween()
		tween.tween_property(self, "global_position", target_pos, move_time).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		is_moving = false

func record_movement(dir):
	recording.append(dir)
	#print(recording)

func replay_movements():
	for dir in recording:
		await move_clone(dir)
		
func _on_player_input_pressed() -> void:
	if num_of_moves > 0:
		num_of_moves -= 1
		print(num_of_moves)
		if num_of_moves == 0:
			disappear()

func disappear():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(queue_free)
	
func self_destruct():
	is_controlled = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1).set_delay(0.4)
	await tween.finished
	print("BOOM!")
	player.is_controlled = true
	queue_free()
