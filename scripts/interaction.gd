extends Node2D

class_name InteractionManager

@export var node: Node
@export var interact_text: String = ""
@onready var label = $Label
var can_interact: bool = false

func update_label_text(text: String) -> void:
	label.text = text

func _ready():
	update_label_text(interact_text)
	label.global_position = Vector2(node.global_position.x - (label.size.x / 2), node.global_position.y - 100)
	label.hide()

func _on_interaction_area_body_entered(_body):
	can_interact = true
	label.show()

func _on_interaction_area_body_exited(_body):
	can_interact = false
	label.hide()
