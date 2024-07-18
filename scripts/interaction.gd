extends Node2D

class_name InteractionManager

@export var interact_text: String = ""
@export var label_y_offset: int = 100
@onready var label: Label = $Label
@onready var parent_node := get_parent()
var can_interact: bool = false

func update_label_text(text: String) -> void:
	label.text = text

func _ready() -> void:
	update_label_text(interact_text)
	label.global_position = Vector2(
		parent_node.global_position.x - (label.size.x / 2),
		parent_node.global_position.y - label_y_offset)
	label.hide()

func _on_interaction_area_body_entered(_body) -> void:
	can_interact = true
	label.show()

func _on_interaction_area_body_exited(_body) -> void:
	can_interact = false
	label.hide()
