extends Node
class_name Network #신경망? 이런 느낌.
var layers = []
var biases = []

func _init():#초기화 합니다.
	var layer_sizes = [5,10,4,3,1]
	for i in range(layer_sizes.size() - 1):
		layers.append(Array())
		biases.append(Array())
		for _j in range(layer_sizes[i + 1]):
			layers[i].append(Array())
			for _k in range(layer_sizes[i]):
				layers[i][_j].append(randf() * 2.0 - 1.0) # -1.0 ~ 1.0 의 실수를 랜덤하게 유전자로 설정합니다.
			biases[i].append(randf() * 2.0 - 1.0) # -1.0 ~ 1.0 의 실수를 랜덤하게 유전자로 설정합니다.
	
func set_gene(gene_array):#유전자를 입력받아 네트워크 weight들을 업데이트 합니다.
	var index = 0
	for i in range(layers.size()):
		for j in range(layers[i].size()):
			for k in range(layers[i][j].size()):
				layers[i][j][k] = gene_array[index]
				index += 1
			biases[i][j] = gene_array[index]
			index += 1
	pass
	
func get_gene():#네트워크의 레이어와 바이어스 구조를 유전자화(배열화)하여 반환합니다.
	var gene = []
	for i in range(layers.size()):
		for j in range(layers[i].size()):
			for k in range(layers[i][j].size()):
				gene.append(layers[i][j][k])
			gene.append(biases[i][j])
	return gene

func forward(inputs):#레이어에 인풋을 넣어서 곱한 값을 시그모이드에 넣어서 나온 값을 다시 그 다음 레이어에 넣어서 나온 값을 다시 시그모이드에 넣어서 -> 이거 반복 하는 함수~
	var current_input = inputs
	for i in range(layers.size()):
		var outputs = matrix_multiply(layers[i],current_input,layers[i].size(),layers[i][0].size())
		for j in range(outputs.size()):
			outputs[j] = activation_function(outputs[j] + biases[i][j])
		current_input = outputs
	return current_input

func activation_function(x):
	#시그모이드 함수를 활성화 함수로 사용합니다.
	return 1.0 / (1.0 + exp(-x))
	
func matrix_multiply(a:Array, b:Array, rows_a:int, cols_a:int) -> Array:
	var result = []
	for i in range(rows_a):
		var sum = 0
		for j in range(cols_a):
			sum += a[i][j] * b[j]
		result.append(sum)
	return result
