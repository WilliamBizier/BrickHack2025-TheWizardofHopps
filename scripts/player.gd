class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 70.0

#0 means idle, 1 means left, 2 means right 3 means down
var face = 0

var count = 0

func _ready():
	pass


func _process(delta):
	
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = direction * SPEED
	
	
	if Input.is_action_just_pressed("Action"):
		print('fireball')
		face=5
		animated_sprite.play('fireball_cast')
	
	if Input.is_action_just_pressed("Left") and face != 1 and face!=5:
		animated_sprite.play('run')
		animated_sprite.flip_h = true
		face = 1
	elif Input.is_action_just_pressed("Right") and face != 2:
		animated_sprite.play('run')
		animated_sprite.flip_h = false
		face = 2
	elif Input.is_action_just_pressed("Up") and face != 3:
		face = 3
		pass
	elif Input.is_action_just_pressed("Down") and face != 0:
		animated_sprite.play('idle')
		face = 0
		pass	
	
	if velocity == Vector2.ZERO and face != 5:
		animated_sprite.play('idle')
		face = 0
		
	
func _physics_process(delta: float):
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
