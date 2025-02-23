class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var canvas_layer: Node = get_tree().root.get_node("game/CanvasLayer")  # Adjust path to CanvasLayer
@onready var canvas_sprite: AnimatedSprite2D = canvas_layer.get_node("Healthbar")  # Adjust path to AnimatedSprite2D inside CanvasLayer

const SPEED = 70.0

# 0 means idle, 1 means left, 2 means right, 3 means down
var face = 0

var count = 0
var fireball = false

var health = 4  # Starting health is 4
var drunk = 0

func _ready():
	add_to_group("player")  # Add player to the "player" group for collision detection
	print("Canvas Layer Sprite: ", canvas_sprite)  # Debugging line to check if the sprite is accessed

func _process(delta: float):
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = direction * SPEED
	
	if fireball and count < 120:
		count += 1
	elif count == 120:
		count = 0
	
	# Ensure the fireball action is triggered only once.
	if Input.is_action_just_pressed("Action") and not fireball:
		print('fireball')
		fireball = true
		face = 5
		animated_sprite.play('fireball_cast')
	
	# Movement animations
	if Input.is_action_just_pressed("Left") and face != 1 and face != 5:
		animated_sprite.play('run')
		animated_sprite.flip_h = true
		fireball = false
		face = 1
	elif Input.is_action_just_pressed("Right") and face != 2:
		animated_sprite.play('run')
		animated_sprite.flip_h = false
		fireball = false
		face = 2
	elif Input.is_action_just_pressed("Up") and face != 3:
		face = 3
		fireball = false
		pass
	elif Input.is_action_just_pressed("Down") and face != 0:
		animated_sprite.play('idle')
		face = 0
		fireball = false
		pass    
	
	# Idle condition
	if velocity == Vector2.ZERO and face != 5 and fireball == false or count == 120:
		animated_sprite.play('idle')
		face = 0
		fireball = false
	
# Physics processing (for movement)
func _physics_process(delta: float):
	move_and_slide()  # This will move and slide based on the velocity

# This function handles the logic when the player collides with the enemy
# The collision and health reduction parts are removed from here.
