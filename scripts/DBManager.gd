extends Node

var db = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var db_path = "user://car_gene_DB.db"
	var db_file = DirAccess.open("user://")
	if not db_file.file_exists(db_path):
		var src_file = FileAccess.open("res://car_gene_DB.db", FileAccess.READ)
		var dst_file = FileAccess.open(db_path,FileAccess.WRITE)
		dst_file.store_buffer(src_file.get_buffer(src_file.get_length()))
		src_file.close()
		dst_file.close()
	db = SQLite.new()
	db.path = db_path
	db.open_db()	
	pass # Replace with function body.
	
func insert_gene(st_time:String,generation:int,no : int, score:float,gene:Array,fail_yn : bool):
	var gene_blob = gene_to_string(gene)
	var query = "INSERT INTO CAR_GENES VALUES('%s', %d, %d, %f, '%s', '%s')" %[st_time,generation,no,score,gene_blob,'1' if fail_yn else '0']
	db.query(query)
	pass
	
func gene_to_string(gene_array:Array) -> String:
	var gene_string = str(gene_array) # [1,2,3,4]
	gene_string = gene_string.substr(1,gene_string.length() - 2) # 양 끝 대괄호 제거	
	return gene_string
	
func string_to_gene(gene_string:String) -> Array:
	var gene_array = []
	var gene_elements = gene_string.split(",")
	for gene_element in gene_elements:
		if gene_element != "":
			gene_array.append(float(gene_element))
	return gene_array

func get_max_two_score_gene(st_time:String, generation:int) -> Array:
	var query = "SELECT GENE FROM CAR_GENES WHERE ST_TIME = '%s' AND GENERATION = %d ORDER BY FAIL_YN DESC, SCORE DESC LIMIT 2 " % [st_time,generation]
	db.query(query)
	var result = []
	for data in db.query_result:
		result.append(string_to_gene(data["GENE"]))
	return result

func get_last_best_gene() -> Array:
	var query = "SELECT GENE FROM CAR_GENES WHERE ST_TIME = (SELECT MAX(ST_TIME) FROM CAR_GENES) ORDER BY FAIL_YN DESC, SCORE DESC LIMIT 1 "
	db.query(query)
	return string_to_gene(db.query_result[0]["GENE"])
