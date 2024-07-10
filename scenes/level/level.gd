extends Node2D

class_name Level

@onready var tile_map = $TileMap
@onready var player = $Player as Player
@onready var playerClone = preload("res://scenes/player/player_clone.tscn")

var shield_active: bool = false
var num_of_moves: int = 0
var cloneRef: PlayerClone = null

func _ready():
	player.is_controlled = true
	player.connect("powerUpActivated", _on_player_activate_powerup)
	
	var powerups = get_node("Powerups").get_children()
	var obstacles = get_node("Obstacles").get_children()
	var enemies = get_node("Enemies").get_children()
	
	for powerup in powerups:
		powerup.connect("powerUpActivated", _on_player_activate_powerup)
		
	for obstacle in obstacles:
		obstacle.connect("obstacleCollided", _on_obstacle_collided)
		
	for enemy in enemies:
		enemy.connect("enemyCollided", _on_enemy_collided)
	
func _on_player_activate_powerup(activator = null, powerupRef = null) -> void:
	
	if powerupRef is LifeUP and activator is Player:
		Globals.health += 1
	
	elif powerupRef is EnergyUP and activator is Player:
		Globals.energy_charges += 1
	
	elif powerupRef is Shield and activator is Player:
		shield_active = true
		await get_tree().create_timer(powerupRef.shield_duration).timeout
		shield_active = false
		
	elif powerupRef is ChronoLoop and activator is Player:
		if not powerupRef.current_clone:
			player.is_controlled = false
			await get_tree().create_timer(0.1).timeout
			await activator.input_pressed
			spawn_clone(PlayerClone.CloneType.CHRONO_LOOP, powerupRef)

	elif powerupRef is ChronoLoop and activator is PlayerClone:
		if activator.is_recording == true and not activator.recording.is_empty():
			print("Recording Complete")
			activator.is_recording = false
			activator.is_controlled = false
			player.is_controlled = true
			
			 #To Un-pause Other Clone Entities
			var clones = get_node("Player_Clones").get_children()
			for currentClone in clones:
				if currentClone.process_mode == Node.PROCESS_MODE_DISABLED:
					currentClone.process_mode = Node.PROCESS_MODE_INHERIT
					
		if activator.is_recording == false:
			await get_tree().create_timer(0.5).timeout
			activator.replay_movements()
			
	elif powerupRef == "Phantom" and activator is Player:
		spawn_clone(PlayerClone.CloneType.CHRONO_PHANTOM)
		
	elif powerupRef == "Bomb" and activator is Player:
		spawn_clone(PlayerClone.CloneType.CHRONO_BOMB)
		
	else:
		print("Not a signal")
			
func spawn_clone(type: PlayerClone.CloneType, powerupRef = null) -> void:
	var cloneTemp: PlayerClone = playerClone.instantiate()
	cloneTemp.position = player.global_position
	cloneTemp.type = type
	
	if type == PlayerClone.CloneType.CHRONO_LOOP:
		cloneTemp.is_controlled = true
		powerupRef.current_clone = cloneTemp
		cloneTemp.direction = player.direction
		cloneTemp.is_recording = true
		print("Recording")
		
	# To Pause Other Clone Entities
		var clones = get_node("Player_Clones").get_children()
		for currentClone in clones:
			if not (currentClone == cloneTemp):
				currentClone.process_mode = Node.PROCESS_MODE_DISABLED
				
	elif type == PlayerClone.CloneType.CHRONO_PHANTOM:
		cloneRef = cloneTemp
		num_of_moves = 5
	
	elif type == PlayerClone.CloneType.CHRONO_BOMB:
		player.is_controlled = false
		cloneTemp.is_controlled = true
		cloneTemp.num_of_moves = 6
		
	var node = get_node("Player_Clones")
	node.add_child.bind(cloneTemp).call_deferred()

func _on_player_input_pressed() -> void:
	if num_of_moves > 0:
		num_of_moves -= 1
		print(num_of_moves)
		if num_of_moves == 0:
			var tween = create_tween()
			tween.tween_property(cloneRef, "modulate:a", 0, 1)
			tween.tween_callback(delete_clone)

func delete_clone() -> void:
	cloneRef.queue_free()
	cloneRef = null

func _on_obstacle_collided(collider = null, obstacle: Obstacle = null) -> void:

	if collider is Player and obstacle.damage > 0:
		player_hit(obstacle.damage)
	
func player_hit(damage: int):
	if Globals.vulnerability == true and not shield_active:
		Globals.health -= damage
		player.hit_timer_activate()
		
		if Globals.health <= 0:
			print("YoU Ded")

func _on_enemy_collided(collider = null, enemy: Enemy = null) -> void:
	if collider is Player and enemy is HeavyBot:
		player_hit(enemy.damage)
	elif collider is Player and enemy is DroneBot:
		player_hit(enemy.damage)
	elif collider is Player and enemy is RollerBot:
		player_hit(enemy.damage)
