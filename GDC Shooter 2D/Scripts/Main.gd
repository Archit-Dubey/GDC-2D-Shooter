extends Node2D

# Identify number and types of enemies into an array
@export var enemy_scenes: Array[PackedScene] = []
@export var powerups_scenes: Array[PackedScene] = []

@export var max_enemies = 10
@export var max_powerups = 5
@export var boundary_x=5000
@export var boundary_y=5000
@export var maxSpawnRange = 1000

@onready var spawncheck=$powerupSpawnChecker
@onready var player = $Player
@onready var enemy_container = $Enemy_Container
@onready var powerups_container = $Powerups_Container
@onready var bossShip=preload("res://Scenes/bossShip.tscn")
@onready var bossTimer=$BossTimer

var spawnedBosses=[]

var enemy_count = 0
var powerups_count = 0
var spawn_powerup=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):#physics process because raycast is involved
	if spawn_powerup:
		
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
			
		var selectPos=Vector2(player.global_position.x + random.randi_range(-maxSpawnRange, maxSpawnRange), player.global_position.x + random.randi_range(-maxSpawnRange, maxSpawnRange))
			#selects position , seperated to check for asteroids
		
		powerups.global_position = selectPos
		powerups_container.add_child(powerups)
		spawn_powerup=false
		
	var player_pos=player.global_position
	
	#check if player is outside bounds
	if abs(player_pos.x)>boundary_x or abs(player_pos.y)>boundary_x:
		if bossTimer.is_stopped():
			bossTimer.start()
		
	else:#player is inside bounds
		if len(spawnedBosses)>0:
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
		#flags to _physics_process to spawn in a powerup, doing it here with checking
		#will cause severe slowdowns and game crashes (took 1 hour to realize :( )
		spawn_powerup=true
	
	else:
		pass


func _on_boss_timer_timeout():
	print("spawning boss")
	spawnedBosses.append(bossShip.instantiate())
	var ind=len(spawnedBosses) -1
	spawnedBosses[ind].add_to_group("Enemy")
	spawnedBosses[ind].global_position=player.global_position+((player.global_position).normalized()*1000)
	add_child(spawnedBosses[ind])
