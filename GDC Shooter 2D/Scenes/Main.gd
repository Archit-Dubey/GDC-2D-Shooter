extends Node2D

# Identify number and types of enemies into an array
@export var enemy_scenes: Array[PackedScene] = [] 
@export var max_enemies = 10

@onready var timer  = $Enemy_Spawner_Timer
@onready var player = $Player
@onready var enemy_container = $Enemy_Container

var enemy_count = 0

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
