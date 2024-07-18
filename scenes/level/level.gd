extends Node2D

class_name Level

@onready var tile_map = $TileMap as TileMap
@onready var player = $Player as Player
@onready var playerClone: PackedScene = preload("res://scenes/player/player_clone.tscn")

func _ready() -> void:
	player.is_controlled = true
	player.connect("powerUpActivated", _on_player_activate_powerup)
	
	var powerups := get_node("Powerups").get_children()
	var obstacles := get_node("Obstacles").get_children()
	var enemies := get_node("Enemies").get_children()
	
	for powerup in powerups:
		powerup.connect("powerUpActivated", _on_player_activate_powerup)
		
	for obstacle in obstacles:
		if not obstacle is WoodenBox:
			obstacle.connect("obstacleCollided", _on_obstacle_collided)
		
	for enemy in enemies:
		enemy.connect("enemyCollided", _on_enemy_collided)
	
func _on_player_activate_powerup(activator = null, powerupRef = null) -> void:
	
	if activator is PlayerClone and powerupRef is ChronoLoop:
		if activator.is_recording == true and not activator.recording.is_empty():
			print("Recording Complete")
			powerupRef.interaction_area.update_label_text("Press Q to Reset")
			activator.is_recording = false
			activator.is_controlled = false
			player.is_controlled = true
			
			#To Un-pause Other Clone Entities
			var clones = get_node("Player_Clones").get_children()
			for currentClone in clones:
				if currentClone.process_mode == Node.PROCESS_MODE_DISABLED:
					currentClone.process_mode = Node.PROCESS_MODE_INHERIT
					
		if activator and activator.is_recording == false:
			activator.replay_movements()
	
	elif activator is Player or activator == "Player":
		
		if powerupRef is LifeUP:
			Globals.health += 1
		
		elif powerupRef is EnergyUP:
			Globals.energy_charges += 1
		
		elif powerupRef is Shield:
			Globals.shield = true
			await get_tree().create_timer(powerupRef.shield_duration).timeout
			Globals.shield = false
			
		elif powerupRef is ChronoLoop:
			if powerupRef.current_clone == null:
				powerupRef.interaction_area.update_label_text("")
				player.is_controlled = false
				spawn_clone(PlayerClone.CloneType.CHRONO_LOOP, powerupRef)
				
		elif powerupRef == "Phantom":
			spawn_clone(PlayerClone.CloneType.CHRONO_PHANTOM)
			
		elif powerupRef == "Bomb":
			spawn_clone(PlayerClone.CloneType.CHRONO_BOMB)

func spawn_clone(type: PlayerClone.CloneType, powerupRef = null) -> void:
	var cloneTemp := playerClone.instantiate() as PlayerClone
	cloneTemp.type = type
	
	if type == PlayerClone.CloneType.CHRONO_LOOP:
		powerupRef.current_clone = cloneTemp
		cloneTemp.position = powerupRef.position
		cloneTemp.direction = player.direction
		cloneTemp.is_controlled = true
		cloneTemp.is_recording = true
		print("Recording")
		
	# To Pause Other Clone Entities
		var clones := get_node("Player_Clones").get_children()
		for currentClone in clones:
			if not (currentClone == cloneTemp):
				currentClone.process_mode = Node.PROCESS_MODE_DISABLED

	elif type == PlayerClone.CloneType.CHRONO_BOMB:
		cloneTemp.position = player.global_position
		player.is_controlled = false
		cloneTemp.is_controlled = true
		
	var node = get_node("Player_Clones")
	node.add_child.bind(cloneTemp).call_deferred()

func _on_obstacle_collided(collider = null, obstacle: Obstacle = null) -> void:

	if collider is Player and obstacle.damage > 0:
		player_hit(obstacle.damage)
	
func player_hit(damage: int) -> void:
	if Globals.vulnerability == true and not Globals.shield:
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
