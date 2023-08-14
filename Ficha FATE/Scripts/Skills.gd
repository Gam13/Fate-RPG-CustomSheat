extends Panel
@onready var skill_grid = $MarginContainer/SkillGrid


var skill_list : skillList: set = _set_skill_list
var slot_data = preload("res://Scenes/SlotData.tscn")
var actualOption : int = -1

signal disabledOption
signal update_stress
signal trashPressed(skill_list : skillList)

#==============================================================================
#======================Atualiza as Skills em Display===========================
func _set_skill_list(list : skillList):
	skill_list = list
	skill_list.update_skills.connect(updateSkills)#conecta o sinal que avisa pra atualizar as skills

func updateSkills() -> void:
	#==Remove todos os quadrados de skill instânciados até então
	for child in skill_grid.get_children():
		child.queue_free()
	skill_list.updateValue()
	##Re-instancia os quadrados de skill
	
	for Skill in skill_list.SkillTotal:
		var skillSlot = slot_data.instantiate()
		skill_grid.add_child(skillSlot)
		#conecta o sinal de se clicar no slot de skill avisar que foi clicado
		skillSlot.slot_clicked.connect(skill_list.on_slot_clicked)
		#==========================================================================
		#Se aquele quadrado tiver uma skill, atualizar o botão para o nome da skill
		if Skill:

			skillSlot.set_skill_slot(Skill.name)
	#===================Emite o sinal para atualizar o Stress===================
	emit_signal("update_stress")
#######################Fim da Atualização de Display############################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
#==============================================================================
#======================Botão para adicionar novas skills=======================
func _on_button_pressed():
	var skillDefault : skill_data =  skill_data.new()
	match actualOption:
		0:
			skill_list.newSkill(skillDefault)
			
		1:
			skill_list.newSkill(preload("res://Resourcers/vitality.tres"))
			emit_signal("disabledOption")
			actualOption = 0
		2:
			skill_list.newSkill(preload("res://Resourcers/sanity.tres"))
			emit_signal("disabledOption")
			actualOption = 0
	
	updateSkills()
##========Função que verifica qual tipo de skill vai ser instanciada============
func _on_option_button_item_selected(index):
	actualOption = index
#=====================Sinal que a lixeira foi ultilizada========================
func _on_lixeira_pressed():
	emit_signal("trashPressed",skill_list)
