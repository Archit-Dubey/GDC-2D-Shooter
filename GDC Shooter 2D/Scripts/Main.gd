extends Node2D

# Identify number and types of enemies into an array
@export var enemy_scenes: Array[PackedScene] = []
@export var powerups_scenes: Array[PackedScene] = []

@export var max_enemies = 10
@export var max_powerups = 30

@export var maxSpawnRange = 1000

@onready var player = $Player
@onready var enemy_container = $Enemy_Container
@onready var powerups_container = $Powerups_Container

var enemy_count = 0
var powerups_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_spawner_timer_timeout():
	
	enemy_count = enemy_container.get_child_count()
	
	if(enemy_count < max_enemies):
		# Start a random number generator to randomize the spawning position
		var random = RandomNumberGenerator.new()
		random.randomize()
	
		# Random enemy will be spawned around the player	
		var enemy = enemy_scenes.pick_random().instantiate()
		enemy.global_position = Vector2(player.global_position.x + random.randi_range(-500, 500),player.global_position.y + random.randi_range(-500, 500))
		enemy_container.add_child(enemy)
	
	else:
		pass


func _on_powerups_spawner_timer_timeout():
	
	powerups_count = powerups_container.get_child_count()
	
	if(powerups_count < max_powerups):
		# Start a random number generator to randomize the spawning position
		var random = RandomNumberGenerator.new()
		random.randomize()
		
		# Random powerups will be spawned in the maxSpawnRange
		var powerups = powerups_scenes[0]
		
		# To not spawn more lives than the maxLives
		# Keep the index of life_powerup.tscn at index 0
		if player.lives < player.maxLives :
			powerups = powerups_scenes.pick_random().instantiate()
		else:
			powerups = powerups_scenes.slice(1,powerups_scenes.size()).pick_random().instantiate()
			
		powerups.global_position = Vector2(player.global_position.x + random.randi_range(-maxSpawnRange, maxSpawnRange), player.global_position.x + random.randi_range(-maxSpawnRange, maxSpawnRange))
		powerups_container.add_child(powerups)
	
	else:
		pass
