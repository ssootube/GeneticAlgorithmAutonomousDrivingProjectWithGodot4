extends Node2D
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_gene():
	return get_child(0).network.get_gene()
	
func set_gene(_gene):
	get_child(0).network.set_gene(_gene)
