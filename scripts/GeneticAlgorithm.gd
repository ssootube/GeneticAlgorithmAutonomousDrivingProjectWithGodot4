extends Node
class_name GeneticAlgorithm

var population = [] #개체
var mutation_rate = 0.05 #돌연변이 확률
var scores = [] # 점수 (일단 선언부터.)
var car_scene = preload("res://node/car.tscn")

func _init(parent_node, population_size, gene_size):#완성
	#초기 값을 받아 첫번째 세대를 랜덤한 유전자로 생성합니다.
	for i in range(population_size):
		var gene = []
		for j in range(gene_size):
			gene.append(randf() * 2.0 - 1.0) # -1.0 ~ 1.0 의 실수를 랜덤하게 유전자로 설정합니다.
		population.append(instantiate_car(parent_node,gene))

func get_pos():
	return Vector2(0,0)
	
func instantiate_car(parent_node,child_gene):#완성
	#child_gene을 받아 인스턴스화 한 객체를 반환한다.
	var object_car = car_scene.instantiate()	
	object_car.global_transform.origin = get_pos()
	parent_node.add_child(object_car)
	object_car.set_gene(child_gene)
	return object_car
	
func get_two_max_indices(scores): #완성
	#population에서 가장 높은 점수를 가지는 개체의 인덱스 값을 반환합니다.(상위 2개) 배열 형태로.
	var max_index1 = 0
	var max_index2 = 0
	
	for i in range(len(scores)):
		if scores[i] > scores[max_index1]:
			max_index2 = max_index1
			max_index1 = i
		elif scores[i] > scores[max_index2]:
			max_index2 = i
	return [max_index1,max_index2]
	
func evolve(parent_node): #완성
	calculate_scores() #먼저 점수를 계산합니다.
	var max_indices = get_two_max_indices(scores)
	var best_gene1 = population[max_indices[0]].get_gene()
	var best_gene2 = population[max_indices[1]].get_gene()
	
	print("best score : ", scores[max_indices[0]])
	
	var new_population = [] #다음 세대가 될 개체들을 담을 배열.
	var new_population_count = len(population) #다음 세대의 자식들을, 현 세대의 개체수 만큼 생성합니다.
	for i in range(new_population_count):
		var child_gene = crossover(best_gene1,best_gene2)
		child_gene = mutate(child_gene)
		new_population.append(instantiate_car(parent_node,child_gene))
	
	#기존 세대 객체들을 모두 삭제한다.
	for element in population:
		element.queue_free()
	population = new_population
	
	
	pass
	
func crossover(parent1_gene, parent2_gene): #완성
	#유전자 교차 함수. parent1_gene과 parent2_gene를 교차한다.
	var my_child_gene = []
	for i in range(len(parent1_gene)):
		if randf() < 0.5:
			my_child_gene.append(parent1_gene[i])
		else:
			my_child_gene.append(parent2_gene[i])
	return my_child_gene
	
func mutate(child_gene): #완성
	#돌연변이를 발생시킨다.
	for i in range(len(child_gene)):
		if randf() < mutation_rate:
			child_gene[i] = randf() * 2.0 - 1.0 # -1.0 ~ 1.0 사이의 실수를 랜덤하게 설정.
	return child_gene

func calculate_scores():
	#점수를 계산하여 scores 배열에 담습니다.
	scores = []
	for car in population:
		scores.append(car.score)
	pass
	
