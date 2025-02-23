class_name Player extends CharacterBody2D


const SPEED = 70.0


func _ready():
	pass


func _process(delta):
	
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = direction * SPEED
	
	if Input.is_action_just_pressed("Action"):
		print("fireball")
	
func _physics_process(delta: float):
	move_and_slide()
