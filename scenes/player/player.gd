extends CharacterBody2D

class_name Player

signal input_pressed
signal powerUpActivated(activator, powerupRef)

@export var MAX_SPEED: int = 500
var speed: int = MAX_SPEED
var direction: Vector2i = Vector2i.DOWN
var target_pos: Vector2
var is_moving: bool = false
var is_controlled: bool = true
var is_move_key_pressed: bool = false
var push_dirs: Array[bool] = [true,true,true,true]

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var tile_map = get_node("../TileMap") as TileMap

func _ready() -> void:
	anim.play("Idle_Front")

func _physics_process(delta: float) -> void:
	if is_controlled and not is_moving:
		player_input()

	elif is_moving:
		move_player(delta)
	
	if not is_controlled and is_move_key_pressed:
		input_pressed.emit()

func cant_push(dir: Vector2i):
	push_dirs[0] = false if dir == Vector2i.LEFT else true
	push_dirs[1] = false if dir == Vector2i.RIGHT else true
	push_dirs[2] = false if dir == Vector2i.UP else true
	push_dirs[3] = false if dir == Vector2i.DOWN else true

func player_input() -> void:
	# Player Movement Controls
	is_move_key_pressed = false
	
	if Input.is_action_pressed("Left") and push_dirs[0]:
		get_target_pos(Vector2i.LEFT)
	elif Input.is_action_pressed("Right") and push_dirs[1]:
		get_target_pos(Vector2i.RIGHT)
	elif Input.is_action_pressed("Up") and push_dirs[2]:
		get_target_pos(Vector2i.UP)
	elif Input.is_action_pressed("Down") and push_dirs[3]:
		get_target_pos(Vector2i.DOWN)

	# Player Abilities
		
	if Input.is_action_just_pressed("Phantom") and Globals.energy_charges > 0:
		Globals.energy_charges -= 1
		powerUpActivated.emit(self,"Phantom")
		
	elif Input.is_action_just_pressed("Bomb") and Globals.energy_charges > 1:
		Globals.energy_charges -= 2
		powerUpActivated.emit(self,"Bomb")

func get_target_pos(dir: Vector2i) -> void:
	direction = dir
	is_moving = true
	is_move_key_pressed = true
	input_pressed.emit()
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var tile_data := tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		target_pos = tile_map.map_to_local(target_tile)

func move_player(delta: float) -> void:
	global_position = global_position.move_toward(target_pos,speed * delta)
	
	if global_position == target_pos:
		is_moving = false

func emp_hit(time: int):
	$EmpTimer.start(time)
	@warning_ignore("integer_division")
	speed = MAX_SPEED / 2

func hit_timer_activate() -> void:
	Globals.vulnerability = false
	$HitTimer.start()

func _on_hit_timer_timeout() -> void:
	Globals.vulnerability = true

func _on_emp_timer_timeout():
	speed = MAX_SPEED

