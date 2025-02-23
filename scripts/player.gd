class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var canvas_layer: Node = get_tree().root.get_node("game/CanvasLayer")  # Adjust path to CanvasLayer
@onready var canvas_sprite: AnimatedSprite2D = canvas_layer.get_node("Healthbar")  # Adjust path to AnimatedSprite2D inside CanvasLayer
@onready var canvas_sprite1: AnimatedSprite2D = canvas_layer.get_node("beerbar")  # Adjust path to AnimatedSprite2D inside CanvasLayer

const SPEED = 70.0

# 0 means idle, 1 means left, 2 means right, 3 means down
var face = 0

var count = 0
var fireball = false

var health = 4  # Starting health is 4
var drunk = 0  # Drunk counter (0 to 5)
var game_over = false
var drinking = false  # To track if the player is in the drinking animation
var fireball_active = false  # To track if the fireball animation is playing

func _ready():
	add_to_group("player")  # Add player to the "player" group for collision detection
	print("Canvas Layer Sprite: ", canvas_sprite)  # Debugging line to check if the sprite is accessed
	
	# Correctly connect the animation_finished signal to the function
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta: float):
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = direction * SPEED

	if fireball and count < 120:
		count += 1
	elif count == 120:
		count = 0
	
	# Ensure the fireball action is triggered only once and if drunk counter is greater than 0
	if Input.is_action_just_pressed("Action") and not fireball and drunk > 0:
		print('fireball')
		fireball = true
		fireball_active = true
		face = 5
		# Play fireball cast animation, and ensure it does not loop
		animated_sprite.play('fireball_cast', true)  # The second argument being 'true' makes sure it's a one-shot animation
		
		# Decrease drunk counter after casting fireball (ensure it doesn't go below 0)
		if drunk > 0:
			drunk -= 1
		# Update the Beer bar based on the drunk state after using fireball
		update_beer_bar()
	
	# Movement animations (if not drinking)
	if not drinking:
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
		elif Input.is_action_just_pressed("Down") and face != 0:
			animated_sprite.play('idle')
			face = 0
			fireball = false
	
	# Idle condition (if no movement input and not drinking)
	if velocity == Vector2.ZERO and face != 5 and not drinking:
		animated_sprite.play('idle')
		face = 0
		fireball = false
	
	# Check if the "Drink" action is triggered and the player is not already drinking
	if Input.is_action_just_pressed("Drink") and not drinking:
		print("Drink key pressed!")  # Debugging line to confirm the key press
		drinking = true  # Set the flag that player is drinking
		
		# Stop any current animation and play Beer animation (do not loop)
		if animated_sprite.animation != "Beer":  # Prevent re-playing if already in the animation
			print("Playing Beer animation")  # Debugging line to confirm animation is triggered
			animated_sprite.stop()  # Stop any current animation
			animated_sprite.play("Beer", true)  # The second argument being 'true' ensures one-shot behavior

# This function is called when any animation finishes
func _on_animation_finished():
	# If the Beer or Fireball animation finishes
	print("Animation finished: ", animated_sprite.animation)  # Debugging to check which animation finished
	if animated_sprite.animation == "Beer":
		drinking = false
		fireball_active = false
		# Increase drunk counter after drinking beer (ensure it doesn't go over 5)
		if drunk < 5:
			drunk += 1
		# Update the Beer bar based on the drunk state
		update_beer_bar()

	# After the Fireball animation or Beer animation ends, switch to idle
	if animated_sprite.animation == "fireball_cast" or animated_sprite.animation == "Beer":
		# Ensure we return to idle animation after the beer or fireball animation finishes
		if velocity == Vector2.ZERO:  # If the player is not moving, return to idle
			animated_sprite.play("idle")
		elif face == 1:  # If moving left
			animated_sprite.play('run')
		elif face == 2:  # If moving right
			animated_sprite.play('run')
		elif face == 3:  # If moving down
			animated_sprite.play('run')
		else:  # Ensure idle state if nothing is happening
			animated_sprite.play("idle")

# Update the Beer bar in the CanvasLayer based on the drunk level
func update_beer_bar():
	if drunk == 0:
		canvas_sprite1.play("beer0")  # Play beer0 animation (empty)
	elif drunk == 1:
		canvas_sprite1.play("beer1")
	elif drunk == 2:
		canvas_sprite1.play("beer2")
	elif drunk == 3:
		canvas_sprite1.play("beer3")
	elif drunk == 4:
		canvas_sprite1.play("beer4")
	elif drunk == 5:
		canvas_sprite1.play("beer5")  # Play beer5 animation (fully drunk)

# Physics processing (for movement)
func _physics_process(delta: float):
	move_and_slide()  # This will move and slide based on the velocity
