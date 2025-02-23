extends Area2D

@onready var timer: Timer = $Timer  # Reference to the Timer node
@onready var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")  # Path to the Enemy scene

var enemies_spawned = 0
var max_enemies = 50  # Maximum number of enemies to spawn per cycle

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the Timer's timeout signal to a custom function using callable
	timer.timeout.connect(_on_timeout)
	
	# Start the timer for periodic enemy spawning
	timer.start()

# Called every time the timer reaches its timeout (every 2 seconds)
func _on_timeout():
	# Check if we still need to spawn more enemies
	if enemies_spawned < max_enemies:
		spawn_enemy()
		enemies_spawned += 1
	else:
		# Reset the spawn count and stop the timer if all enemies have spawned
		enemies_spawned = 0
		timer.stop()

# Function to spawn an enemy
func spawn_enemy():
	var enemy_instance = enemy_scene.instantiate()  # Instantiate the enemy
	# Randomize the enemy position inside the spawn area
	var random_position = Vector2(randf_range(-50, 50), randf_range(-50, 50))  # Use randf_range instead of rand_range
	enemy_instance.position = position + random_position  # Set the spawn position
	
	# Add the enemy instance to the scene
	get_parent().add_child(enemy_instance)
	print("Enemy spawned at: ", enemy_instance.position)
