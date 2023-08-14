extends Panel

var Vitality = preload("res://Resourcers/vitality.tres")
var Sanity = preload("res://Resourcers/sanity.tres")
var StressBox = preload("res://Scenes/StressBox.tscn")

@onready var health_bar = $"Label Phisical Stress/PhisicalContainer/HealthTotal/Health Bar"
@onready var mental_bar = $"Label Mental Stress/MentalContainer/MentalTotal/Mental Bar"
func _process(_delta):
	changeStressBoxNumber(health_bar)
	changeStressBoxNumber(mental_bar)

func updateStress():
	instantiateStress(Vitality,health_bar)
	instantiateStress(Sanity,mental_bar)
	

#instancia as caixas de Stress
func instantiateStress(status : skill_data,bar : HBoxContainer)->void:

	#Limpa as barras, removendo todos os nós filhos
	for child in bar.get_children():
		child.queue_free()

	#Instancia a nova quantidade de Caixas necessárias
	for container in BoxQuantity(status):
		var newContainer = StressBox.instantiate()
		bar.add_child(newContainer)
	#Troca o número inserido em cada caixa


#Troca o número inserido na caixa de Stress
func changeStressBoxNumber(bar:HBoxContainer) -> void:
		for i in bar.get_child_count():
			bar.get_child(i).call("updateButton", i+1)
	
#Contabiliza quantas caixas vão ser instanciadas
func BoxQuantity(status : skill_data) -> int:
	if status.value == 1 or status.value == 2:
		return 3
	elif status.value >= 3:
		return 4
	else:
		return 2
