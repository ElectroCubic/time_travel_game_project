@tool
extends Area2D

class_name KeyCard

@export_enum('Red','Green','Blue') var colour: String = 'Red':
	set(value):
		if value != null and value != "":
			colour = value
			set_colour(value)
			self.name = value + 'KeyCard'

func set_colour(col):
	if col == 'Red':
		$Sprite2D.frame_coords.y = 2
	elif col == 'Blue':
		$Sprite2D.frame_coords.y = 3
	elif col == 'Green':
		$Sprite2D.frame_coords.y = 4

func _on_body_entered(body):
	if body.name == "Player":
		body.key_cards.append(colour)
		print(body.key_cards)
		queue_free()
