extends CharacterBody2D

@export var raycase2d_1 : RayCast2D
@export var raycase2d_2 : RayCast2D
@export var raycase2d_3 : RayCast2D
@export var raycase2d_4 : RayCast2D
@export var raycase2d_5 : RayCast2D
@export var speed : float = 200
var updateCicle = 0.1
var kill_time = 1.2
var timer = 0
var repeat_kill_timer = 0
var angle = 0
var network
var didHit = false
var checkVector = Vector2(0,0)

func _ready():
	network = Network.new()
	pass

func _physics_process(delta):
	timer += delta
	repeat_kill_timer += delta
	
	if !didHit: #한번이라도 부딪히면 아웃. 시뮬레이션 중단.
		var vectors = []
		for raycast in [raycase2d_1,raycase2d_2,raycase2d_3,raycase2d_4,raycase2d_5]:
			if raycast.is_colliding(): #충돌중이라면 (센서에 감지된 물체가 있다면)
				var collision_point = raycast.get_collision_point() #감지된 지점 좌표를 얻어옵니다.
				var relative_vector = Vector2().direction_to(collision_point)
				vectors.append(relative_vector)
			else:#충돌된게 없는 경우 (센서에 감지된 게 없는 경우)
				#센서의 가시 거리 끝 지점의 좌표를 반환해보자
				var rotation = raycast.rotation
				var position = raycast.global_transform.origin
				var target_position = position + raycast.target_position.rotated(rotation)
				vectors.append(target_position)	
		if timer >= updateCicle:
			timer = 0
			angle = getAngle(vectors)
		if repeat_kill_timer > kill_time:
			repeat_kill_timer = 0
			if checkVector.distance_to(global_position) < 200:
				didHit = true
			checkVector = global_position
		rotate(angle)
		velocity = Vector2(0,-1).rotated(rotation) * speed #전진할 방향을 설정합니다.
		move_and_slide() #설정된 방향으로 전진합니다.
		get_parent().score += delta
	elif raycase2d_1 != null:
		for raycast in [raycase2d_1,raycase2d_2,raycase2d_3,raycase2d_4,raycase2d_5]:
			raycast.free()
	if didHit == false and get_slide_collision_count() != 0:
		didHit = true
		
		
	
func getAngle(vectors):#센서 값을 input으로 받아서 센서에 따른 각도 값을 return합니다. 단 계산은 인공신경망에 의해 일어납니다.
	var inputs = []
	for vector in vectors:
		inputs.append(vector.x * vector.x + vector.y * vector.y)
	var network_output = network.forward(inputs) #시그모이드는 0~1.0  [0.2]
	return (network_output[0] - 0.5) * 2 # -0.5~0.5
	
	

