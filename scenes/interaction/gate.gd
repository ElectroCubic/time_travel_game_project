@tool
extends Area2D

class_name Gate

@export_enum('Red','Green','Blue') var colour: String = 'Red':
	set(value):
		if value != null and value != "":
			colour = value
			set_colour(value)
			self.name = value + 'Gate'
@onready var tile_map = get_node("../../TileMap") as TileMap

var key_found: bool = false

func set_colour(col) -> void:
	if col == 'Red':
		$Polygon2D.color = Color(Color.RED)
	elif col == 'Green':
		$Polygon2D.color = Color(Color.GREEN)
	elif col == 'Blue':
		$Polygon2D.color = Color(Color.BLUE)

func _ready() -> void:
	tile_map.set_barrier(global_position)
	
func remove_gate() -> void:
	print("Gate Opened")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a",0,0.5)
	await tween.finished
	queue_free()

func _on_body_entered(body) -> void:
	if body.name == "Player":
		for key in body.key_cards:
			if key == colour:
				key_found = true
				tile_map.remove_barrier(global_position)
				body.key_cards.remove_at(body.key_cards.find(key))
				print(body.key_cards)
				remove_gate()

		if not key_found:
			print("KeyCard not Found")
