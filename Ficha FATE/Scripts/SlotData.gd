extends PanelContainer
@onready var skill_slot = $SkillSlot

signal slot_clicked(index : int, button : int)

func set_skill_slot(skill_name : String) -> void:
	skill_slot.visible = true
	skill_slot.updateButton(skill_name)


func _on_skill_slot_gui_input(event):
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	or event.button_index == MOUSE_BUTTON_RIGHT)\
	and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)


func _on_gui_input(event):
	_on_skill_slot_gui_input(event)
