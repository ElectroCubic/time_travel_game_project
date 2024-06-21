extends CanvasLayer

@onready var livesCounterlabel: Label = $LivesCounter/HBoxContainer/Label

func updateCounter():
	livesCounterlabel.text = "Lives: " + str(Globals.player_lives)
	
func _ready():
	updateCounter()

func _process(_delta):
	updateCounter()

