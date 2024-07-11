extends CanvasLayer

@onready var healthlabel: Label = $Health/HBoxContainer/Label
@onready var texture_progress_bar = $EnergyBar/TextureProgressBar
@onready var shield_status = $ShieldStatus

func update_counter():
	healthlabel.text = "Health: " + str(Globals.health)
	texture_progress_bar.value = Globals.energy_charges
	
func update_shield_status():
	if Globals.shield:
		shield_status.text = "Shield: Active"
	else:
		shield_status.text = "Shield: Inactive"
	
func _ready():
	Globals.connect("stat_change", update_stat_label)
	update_stat_label()

func update_stat_label():
	update_counter()
	update_shield_status()
	
