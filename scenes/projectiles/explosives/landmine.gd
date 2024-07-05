extends Obstacle

class_name Landmine

@export var landmine_dmg: int = 1

func _ready():
	damage = landmine_dmg

func _on_body_entered(body):
	if body.name == "Player":
		obstacleCollided.emit(body, self)
	queue_free()

