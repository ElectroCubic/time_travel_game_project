extends CanvasLayer

@onready var healthlabel: Label = $Health/HBoxContainer/Label
@onready var texture_progress_bar: TextureProgressBar = $EnergyBar/TextureProgressBar
@onready var shield_status: Label = $ShieldStatus

func update_counter() -> void:
	healthlabel.text = "Health: " + str(Globals.health)
	texture_progress_bar.value = Globals.energy_charges
	
func update_shield_status() -> void:
	if Globals.shield:
		shield_status.text = "Shield: Active"
	else:
		shield_status.text = "Shield: Inactive"
	
func _ready() -> void:
	Globals.connect("stat_change", update_stat_label)
	update_stat_label()

func update_stat_label() -> void:
	update_counter()
	update_shield_status()
	
