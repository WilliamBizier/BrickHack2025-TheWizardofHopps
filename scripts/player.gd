class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 70.0

#0 means idle, 1 means left, 2 means right 3 means down
var face = 0


func _ready():
	pass


func _process(delta):
	
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = direction * SPEED
	
	if Input.is_action_just_pressed("Action"):
		print("fireball")
	
	if Input.is_action_just_pressed("Left") and face != 1:
		pass
	elif Input.is_action_just_pressed("Right") and face != 2:
		pass
	elif Input.is_action_just_pressed("Up") and face != 3:
		pass
	elif Input.is_action_just_pressed("Down") and face != 0:
		pass	
		
	
func _physics_process(delta: float):
	move_and_slide()
