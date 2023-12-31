extends Control
#Referências dos Nodes filhos de Ficha
@onready var identidade = $Identidade
@onready var aspects = $Aspects
@onready var skills = $Skills
@onready var stress = $Stress
@onready var consequence = $Consequence

@onready var grabbed_slot = $GrabbedSlot
@onready var edit_skill_name = $EditSkillName
#Referência para a lista de Skills
@export var skill_list : skillList

#Sistema de Salvar e Carregar a ficha
var path : String = "user://caracter.tres"
var skillPath : String  = "user://skills.tres"
#Referência para carregar um Slot de Skill
var grabbed_slot_data : skill_data
#Referência para editar o nome de um Skill
var Skill4Text : skill_data

#Roda todo Frame 
func _process(_delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(10,10)
	renameSkill()
#Função que roda quando a cena é carregada
func _ready():
	skill_list = preload("res://Resourcers/skill_list_default.tres")
	skills._set_skill_list(skill_list)
	skill_list.skill_interact.connect(on_skill_interact)
	skills.updateSkills()
	stress.updateStress()
#Atualiza as caixas de Stress
func _on_skills_update_stress():
	stress.updateStress()

#==============================================================================
#======================Arrastar Skills para Slots diferentes===================
func on_skill_interact(skills_list : skillList,index : int, button : int )->void:
	match [grabbed_slot_data, button]:
		#Função que rola dados e também verifica se a skill está sendo arrastada
		[null,MOUSE_BUTTON_LEFT]:
			if Input.is_action_pressed("ui_drag"):
				grabbed_slot_data = skills_list.grab_SkillSlot_data(index)
		#Abre a caixa de texto para editar nomes de Skills 
		[null,MOUSE_BUTTON_RIGHT]:
			if skills_list.chkIndex(index):
				Skill4Text = skills_list.chkIndex(index)
				edit_skill_name.show()
				edit_skill_name.global_position = get_global_mouse_position() - Vector2(210,10)
		#Larga a skill que está sendo arrastada
		[_,MOUSE_BUTTON_LEFT]:
				grabbed_slot_data = skills_list.drop_SkillSlot_data(grabbed_slot_data,index)
	update_grabbed_slot()
#Verifica se algo está sendo carregado para mostrar o icone de arrastar
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
	else:
		grabbed_slot.hide()
#Deleta Skills caso você esteja segunrando e clique na lixeira
func _on_skills_trash_pressed(skills_list : skillList)->void:
	if grabbed_slot_data:
		grabbed_slot_data = skills_list.drop_SkillSlot_data(grabbed_slot_data,-1)
	skills.updateSkills()
	update_grabbed_slot()

#==============================================================================
#=============================Renomear Skills==================================
func renameSkill()-> void:
	if edit_skill_name.visible:
		Skill4Text.name = edit_skill_name.text
		if Input.is_action_just_pressed("ui_confirm"):
			skills.updateSkills()
			edit_skill_name.clear()
func _on_edit_skill_name_text_set():
	edit_skill_name.hide()

#==============================================================================
#=============================Salvar e  Carregar===============================
func save_sheet() -> void:
	var save = SheatData.new()
	save.identity = identidade.get_data()
	save.aspects = aspects.get_data()
	save.Consequences = consequence.get_data()
	ResourceSaver.save(save,path)
	ResourceSaver.save(skill_list,skillPath)
func load_sheet() -> void:
	if load(path):
		var caracter_data = ResourceLoader.load(path)
		skill_list.load_skills(ResourceLoader.load(skillPath))
		identidade.load_data(caracter_data.identity)
		aspects.load_data(caracter_data.aspects)
		consequence.load_data(caracter_data.Consequences)
		skills.updateSkills()


func _on_save_pressed():
	save_sheet()


func _on_load_pressed():
	load_sheet()
