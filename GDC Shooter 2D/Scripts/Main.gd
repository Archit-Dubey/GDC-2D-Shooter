extends Node2D

# Identify number and types of enemies into an array
@export var enemy_scenes: Array[PackedScene] = []
@export var powerups_scenes: Array[PackedScene] = []

@export var max_enemies = 10
@export var max_powerups = 5
@export var boundary_x=5000
@export var boundary_y=5000
@export var maxSpawnRange = 1000

@onready var arrow_navigation_area = $Arrow_Navigation_Area #Reserved for layer 8
@onready var player = $Player
@onready var enemy_container = $Enemy_Container
@onready var powerups_container = $Powerups_Container
@onready var bossShip=preload("res://Scenes/bossShip.tscn")
@onready var bossTimer=$BossTimer

var spawnedBosses=[]

var enemy_count = 0
var powerups_count = 0
var spawn_powerup=false

var org_screenX = null
var org_screenY = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if FileAccess.file_exists("user://sounddata.save"):
		var file = FileAccess.open("user://sounddata.save", FileAccess.READ)
		AudioServer.set_bus_volume_db(1,file.get_var())
	
	# To adjust the size of the navigation area according to screen
	
	org_screenX = get_viewport().get_visible_rect().size.x
	org_screenY = get_viewport().get_visible_rect().size.y
	
	#print(get_tree().get_root().size) # Use this to print the original X and Y
	
	arrow_navigation_area.scale.x = org_screenX / 1152 * 0.9 # 1152 is original X
	arrow_navigation_area.scale.y = org_screenY / 648 * 0.82 # 648 is original Y
	
	# till here screen adjusting



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):#physics process because raycast is involved
	
	# To adjust the size of the navigation area according to screen
	# Remove this part before final deployment
	# This for testing purpose of desktop mode
	
	var screenX = get_viewport().get_visible_rect().size.x
	var screenY = get_viewport().get_visible_rect().size.y
	
	#print(get_tree().get_root().size) # Use this to print the original X and Y
	if screenX != org_screenX or screenY != org_screenY:
		arrow_navigation_area.scale.x = screenX / 1152 * 0.9 # 1152 is original X
		arrow_navigation_area.scale.y = screenY / 648 * 0.82 # 648 is original Y
			
	# till here screen adjusting
	
	if player:  # To keep the navigation area over the player always
		#arrow_navigation_area.global_position = player.global_position
		arrow_navigation_area.global_position = arrow_navigation_area.global_position.move_toward(player.global_position,delta * player.movingspeed)
	
	# Spawning powerup code from here
	
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
		
	# Spawn powerup code ends here
		
	var player_pos=player.global_position
	
	#check if player is outside bounds
	if abs(player_pos.x)>boundary_x or abs(player_pos.y)>boundary_x:
		if bossTimer.is_stopped():
			bossTimer.start()
		
	else:#player is inside bounds
		
		if len(spawnedBosses)>0:
			for i in spawnedBosses:
				if  (i.global_position).distance_to(player.global_position)>3000:
					print("killing boss")
					i.queue_free()
					spawnedBosses.erase(i)
			

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
