extends PanelContainer

@onready var button = $"MarginContainer/PanelContainer/Button Label"


func updateButton(Skill_Name : String) -> void:
	button.text = Skill_Name
