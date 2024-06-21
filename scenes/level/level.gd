extends Node2D

@onready var player = $"Player Entities/Player" as Player

var activated = false

func _on_time_fragment_player_touch(pos):
	
	var undoRedo: UndoRedo
	undoRedo.create_action("LoopStart",)
	undoRedo.add_do_method(player.move_player())
	undoRedo.add_do_reference(player)
	undoRedo.commit_action()
	
	while activated:
		if player.is_moving:
			undoRedo.redo()
			
		
