extends Node2D

class_name Level

@onready var tile_map = $TileMap
@onready var player = $Player as Player
@onready var playerClone = preload("res://scenes/player/player_clone.tscn")

func _ready():
	player.is_controlled = true
	var powerups = get_node("Powerups").get_children()
	
	for powerup in powerups:
		powerup.connect("powerUpActivated", _on_player_activate_powerup)
	
	player.connect("powerUpActivated", _on_player_activate_powerup)		
	
func _on_player_activate_powerup(activator = null, powerupRef = null) -> void:
	
	if powerupRef is ChronoLoop and activator is PlayerClone:
		if activator.is_recording == true:
			print("Recording Complete")
			activator.is_recording = false
			activator.is_controlled = false
			player.is_controlled = true
			
			# To Un-pause Other Clone Entities
			#var clones = get_node("Player_Clones").get_children()
			#for currentClone in clones:
				#if currentClone.process_mode == Node.PROCESS_MODE_DISABLED:
					#currentClone.process_mode = Node.PROCESS_MODE_INHERIT
					
		if powerupRef.is_active:
			await get_tree().create_timer(0.5).timeout
			activator.replay_movements()
	
	elif powerupRef is ChronoLoop and activator is Player:	
		if not powerupRef.current_clone:
			player.is_controlled = false
			await activator.input_pressed
			spawn_clone(PlayerClone.CloneType.CHRONO_LOOP, powerupRef)
	
	elif powerupRef == "Phantom" and activator is Player:
		spawn_clone(PlayerClone.CloneType.CHRONO_PHANTOM)
		
	elif powerupRef == "Bomb" and activator is Player:
		spawn_clone(PlayerClone.CloneType.CHRONO_BOMB)
	
	elif powerupRef is LifeUP and activator is Player:
		Globals.player_lives += 1
	
	elif powerupRef is EnergyUP and activator is Player:
		Globals.energy_charges += 1
	else:
		print("Not a signal")
			
func spawn_clone(type: PlayerClone.CloneType, powerupRef = null):
	var cloneTemp: PlayerClone = playerClone.instantiate()

	
	if type == PlayerClone.CloneType.CHRONO_LOOP:
		cloneTemp.position = player.target_pos
		cloneTemp.is_controlled = true
		cloneTemp.type = type
		powerupRef.current_clone = cloneTemp
		cloneTemp.direction = player.direction
		cloneTemp.recording.append(cloneTemp.direction)
		cloneTemp.is_recording = true
		print("Recording")
		
	# To Pause Other Clone Entities
		#var clones = get_node("Player_Clones").get_children()
		#for currentClone in clones:
			#if not (currentClone == cloneTemp):
				#currentClone.process_mode = Node.PROCESS_MODE_DISABLED
				
	elif type == PlayerClone.CloneType.CHRONO_PHANTOM:
		cloneTemp.position = player.global_position
		cloneTemp.type = type
	
	elif type == PlayerClone.CloneType.CHRONO_BOMB:
		cloneTemp.position = player.global_position
		cloneTemp.type = type
	
	get_node("Player_Clones").add_child(cloneTemp)
