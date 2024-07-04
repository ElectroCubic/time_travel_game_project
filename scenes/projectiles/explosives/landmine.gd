extends Obstacle

class_name Landmine

signal obstacleCollided(collider, obstacle: Obstacle)

@onready var landmine = $"." as Landmine

func _on_body_entered(body):
	if body.name == "Player":
		obstacleCollided.emit(body, self)
	queue_free()
