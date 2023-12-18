extends Node2D
var geneticAlgorithm
var evolve_count = 0
var max_car : Node2D = null
@export var my_camera : Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	geneticAlgorithm = GeneticAlgorithm.new(self,50,Network.new().get_gene().size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var checkHit = true
	for car in geneticAlgorithm.population:
		if !car.get_child(0).didHit:
			checkHit = false
	if checkHit :
		next_evolve_start()
		#다음세대 돌입
	move_camera()
	pass
	
func next_evolve_start():
	geneticAlgorithm.evolve(self)
	evolve_count += 1
	
func move_camera():
	if max_car == null:
		max_car = geneticAlgorithm.population[0]
	elif max_car.get_child(0).didHit:
		for car in geneticAlgorithm.population:
			if max_car == null:
				max_car = car
			else:
				max_car = car if max_car.score - car.score < 0.2 else max_car
	my_camera.position = max_car.get_child(0).global_position
	
	
