extends CanvasLayer

@onready var livesCounterlabel: Label = $LivesCounter/HBoxContainer/Label
@onready var energychargelabel: Label = $EnergyCharges/HBoxContainer/Label

func updateCounter():
	livesCounterlabel.text = "Lives: " + str(Globals.player_lives)
	energychargelabel.text = "Charges: " + str(Globals.energy_charges)
	
func _ready():
	Globals.connect("stat_change", update_stat_label)
	updateCounter()

func update_stat_label():
	updateCounter()
