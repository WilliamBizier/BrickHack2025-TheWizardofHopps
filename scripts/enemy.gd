extends AnimatedSprite2D

@onready var raycast_up: RayCast2D = $Up
@onready var raycast_down: RayCast2D = $Down
@onready var raycast_left: RayCast2D = $Left
@onready var raycast_right: RayCast2D = $Right

@onready var player: Player = get_tree().root.get_node("game/player")  # Adjust path to player node
@onready var canvas_layer: CanvasLayer = get_tree().root.get_node("game/CanvasLayer")  # Path to the CanvasLayer
@onready var health_display: AnimatedSprite2D = canvas_layer.get_node("Healthbar")  # Path to the health display

var speed: float = 30  # Speed at which the enemy moves toward the player

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Enable the raycasts
	raycast_up.enabled = true
	raycast_down.enabled = true
	raycast_left.enabled = true
	raycast_right.enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Perform raycasting in each direction to check if any ray hits the player
	if raycast_up.is_colliding():
		var collider = raycast_up.get_collider()  # Get the object that the ray hit
		if collider and collider.is_in_group("player"):
			# If the player is casting fireball, destroy the enemy without hurting the player
			if player.fireball_active:
				print("Enemy hit by fireball!")
				queue_free()  # Destroy the enemy
			else:
				print("Player is hit by the enemy (Up)!")
				collider.health -= 1  # Reduce the player's health
				print("Player's health: " + str(collider.health))
				# Update the health display on the canvas layer
				update_health_display(collider.health)
				# Immediately delete the enemy after the first collision
				queue_free()

	if raycast_down.is_colliding():
		var collider = raycast_down.get_collider()
		if collider and collider.is_in_group("player"):
			# If the player is casting fireball, destroy the enemy without hurting the player
			if player.fireball_active:
				print("Enemy hit by fireball!")
				queue_free()  # Destroy the enemy
			else:
				print("Player is hit by the enemy (Down)!")
				collider.health -= 1
				print("Player's health: " + str(collider.health))
				# Update the health display on the canvas layer
				update_health_display(collider.health)
				# Immediately delete the enemy after the first collision
				queue_free()

	if raycast_left.is_colliding():
		var collider = raycast_left.get_collider()
		if collider and collider.is_in_group("player"):
			# If the player is casting fireball, destroy the enemy without hurting the player
			if player.fireball_active:
				print("Enemy hit by fireball!")
				queue_free()  # Destroy the enemy
			else:
				print("Player is hit by the enemy (Left)!")
				collider.health -= 1
				print("Player's health: " + str(collider.health))
				# Update the health display on the canvas layer
				update_health_display(collider.health)
				# Immediately delete the enemy after the first collision
				queue_free()

	if raycast_right.is_colliding():
		var collider = raycast_right.get_collider()
		if collider and collider.is_in_group("player"):
			# If the player is casting fireball, destroy the enemy without hurting the player
			if player.fireball_active:
				print("Enemy hit by fireball!")
				queue_free()  # Destroy the enemy
			else:
				print("Player is hit by the enemy (Right)!")
				collider.health -= 1
				print("Player's health: " + str(collider.health))
				# Update the health display on the canvas layer
				update_health_display(collider.health)
				# Immediately delete the enemy after the first collision
				queue_free()

	# Move the enemy toward the player
	var direction = player.position - position
	var distance = direction.length()
	
	if distance > 1:  # Only move if the enemy isn't already at the player
		direction = direction.normalized()
		position += direction * speed * delta


# Function to update the health display based on the player's current health
func update_health_display(health: int) -> void:
	# Update health animation depending on the player's health
	if health == 3:
		health_display.play("h3")
	elif health == 2:
		health_display.play("h2")
	elif health == 1:
		health_display.play("h1")
	else:
		health_display.play("h4")  # Assuming "h4" is the animation for full health
