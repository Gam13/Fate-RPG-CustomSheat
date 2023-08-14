class_name skillList extends Resource
signal skill_interact(skill_list : skillList,index : int, button : int )
signal update_skills
@export var Avarage : Array[skill_data]
@export var Fair : Array[skill_data]
@export var Good : Array[skill_data]
@export var Great : Array[skill_data]
@export var Superb : Array[skill_data]

var SkillTotal : Array[skill_data]

##Atualiza o valor da skill dependendo de qual vetor ela está
func updateValue() -> void:
	for each in Superb:
		if each:
			each.value = 5
	
	for each in Great:
		if each:
			each.value = 4

	for each in Good:
		if each:
			each.value = 3
	for each in Fair:
		if each:
			each.value = 2
	
	for each in Avarage:
		if each:
			each.value = 1
	SkillTotal.clear()
	SkillTotal.append_array(Superb)
	SkillTotal.append_array(Great)
	SkillTotal.append_array(Good)
	SkillTotal.append_array(Fair)
	SkillTotal.append_array(Avarage)

#Adiciona uma skill, no primeiro vetor disponível
func newSkill(skill : skill_data):
	if verifySlot(Avarage,skill) == false:
		if verifySlot(Fair,skill) == false:
			if verifySlot(Good,skill) == false:
				if verifySlot(Great,skill) == false:
					verifySlot(Superb,skill)
#Funções para adicionar um slot novo
func verifySlot(list : Array[skill_data], skill:skill_data)->bool:
	
	for each in list:
		if each == null:
			list.erase(each)
			list.push_front(skill)
			return true
		
	return false
#==============================================================================
#==========Lida com a atualização de dados depois de Arrastar Skills===========
func on_slot_clicked(index : int, button : int)-> void:
	skill_interact.emit(self, index, button)
func grab_SkillSlot_data(index : int) -> skill_data:
	var skillSlot = chkIndex(index)
	if skillSlot:
		clearOldIndex(index)
	update_skills.emit()
	return skillSlot
func drop_SkillSlot_data(grabbedSkillSlot : skill_data, newIndex : int) -> skill_data:
	var skillSlot = chkIndex(newIndex)#Verifica se o slot clicado tem alguma Skill
	##Lixeira de Skills
	if newIndex < 0:
		grabbedSkillSlot.value = 0 
		return null
	#=================================================
	#===Substitui o novo index pelo item carregado====
	if newIndex >= 0 and newIndex < 5:
		Superb[newIndex] = grabbedSkillSlot 
	if newIndex >= 5 and newIndex < 10:
		Great[newIndex- 5] = grabbedSkillSlot
	if newIndex >= 10 and newIndex < 15:
		Good[newIndex- 10] = grabbedSkillSlot
	if newIndex >= 15 and newIndex < 20:
		Fair[newIndex- 15] = grabbedSkillSlot
	if newIndex >= 20 and newIndex < 25:
		Avarage[newIndex- 20] = grabbedSkillSlot
	
	update_skills.emit()#Emite um sinal para atualizar a tela
	
	#==Se o slot que foi clicado tiver uma skill====
	#==Retorna a skill como sendo segurada==========
	return skillSlot
func clearOldIndex(oldIndex:int) -> void:
	
	if oldIndex >= 0 and oldIndex < 5:
		Superb[oldIndex] = null
	if oldIndex >= 5 and oldIndex < 10:
		Great[oldIndex- 5]= null
	if oldIndex >= 10 and oldIndex < 15:
		Good[oldIndex- 10]= null
	if oldIndex >= 15 and oldIndex < 20:
		Fair[oldIndex- 15]= null
	if oldIndex >= 20 and oldIndex < 25:
		Avarage[oldIndex- 20]= null
func chkIndex(index : int) -> skill_data:
	var skillSlot = null
	
	if index >= 0 and index < 5:
		skillSlot = Superb[index]
	if index >= 5 and index < 10:
		skillSlot = Great[index- 5]
	if index >= 10 and index < 15:
		skillSlot = Good[index- 10]
	if index >= 15 and index < 20:
		skillSlot = Fair[index- 15]
	if index >= 20 and index < 25:
		skillSlot = Avarage[index- 20]

	return skillSlot
