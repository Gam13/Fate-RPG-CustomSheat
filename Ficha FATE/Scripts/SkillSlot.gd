extends PanelContainer

@onready var button = $"MarginContainer/Button Label"


func updateButton(Skill_Name : String) -> void:
	button.text = Skill_Name
