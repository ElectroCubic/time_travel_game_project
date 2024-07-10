extends CharacterBody2D

class_name Player

signal input_pressed
signal powerUpActivated(activator, powerupRef)

var direction: Vector2 = Vector2.ZERO
var target_pos: Vector2
var target_direction: Vector2
var is_moving: bool = false
var is_controlled: bool = true
var is_move_key_pressed: bool = false

@export var MAX_SPEED: int
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var tile_map = get_node("../TileMap") as TileMap

func _ready():
	anim.play("Idle_Front")

func _process(delta):
	if is_controlled and not is_moving:
		player_input()
		get_target_pos(direction)
	
	if not is_controlled and is_move_key_pressed:
		input_pressed.emit()
	
	move_player(delta)

func player_input():
	# Player Movement Controls
	
	direction = Vector2.ZERO
	is_move_key_pressed = false
	
	if Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
		is_move_key_pressed = true
		input_pressed.emit()
	
	elif Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT
		is_move_key_pressed = true
		input_pressed.emit()
	
	elif Input.is_action_pressed("Up"):
		direction = Vector2.UP
		is_move_key_pressed = true
		input_pressed.emit()
	
	elif Input.is_action_pressed("Down"):
		direction = Vector2.DOWN
		is_move_key_pressed = true
		input_pressed.emit()

	# Player Abilities
		
	if Input.is_action_just_pressed("Phantom") and Globals.energy_charges > 0:
		Globals.energy_charges -= 1
		powerUpActivated.emit(self,"Phantom")
		
	elif Input.is_action_just_pressed("Bomb") and Globals.energy_charges > 1:
		Globals.energy_charges -= 2
		powerUpActivated.emit(self,"Bomb")
	
	elif Input.is_action_just_pressed("Reset"):
		print("Reset")

func get_target_pos(dir: Vector2i):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var tile_data = tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		target_pos = tile_map.map_to_local(target_tile)

func move_player(delta):
	
	# Next up, My Own SOLUTION!1!
	
	is_moving = true
	global_position = global_position.move_toward(target_pos,MAX_SPEED * delta)
	
	if global_position == target_pos:
		is_moving = false
	
	# Smooth Grid Movement but kinda unreliable
	#
	#if not is_moving and is_move_key_pressed:
		#is_moving = true
		#target_direction = direction.normalized()
		#get_target_pos(target_direction)
		#
	#elif is_moving:
		#velocity = MAX_SPEED * target_direction * delta
		#
		#var distance_to_target = global_position.distance_to(target_pos)
		#var move_distance = velocity.length()
		#
		#prints(distance_to_target,move_distance)
		#
		#if distance_to_target < move_distance:
			#velocity = target_direction * distance_to_target
			#is_moving = false
			#
		#move_and_collide(velocity)	
		
	# Kinda Jagged Movement but reliable
			
		#is_moving = true
		#var tween = create_tween()
		#tween.tween_property(self, "global_position", target_pos, move_time).set_trans(Tween.TRANS_SINE)
		#await tween.finished
		#is_moving = false
	pass

func hit_timer_activate():
	Globals.vulnerability = false
	$HitTimer.start()

func _on_hit_timer_timeout():
	Globals.vulnerability = true
