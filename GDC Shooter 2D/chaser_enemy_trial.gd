extends CharacterBody2D

@export var health=20
@export var damageFactor=20
@export var score=100#score increase on death
@export var speed = 200  # Adjust this value to control the speed of the enemy

@onready var navigation_agent = $NavigationAgent2D

@onready var GUI=$"../../GUI"
@onready var player=$"../../Player"
@onready var spawner=$"../.."

var nav_target = null # The target of every navigation

func _ready():
	
	var collision = move_and_collide(Vector2.ZERO)
	if collision:
		if collision.get_collider().is_in_group("Environment"):
			spawner._on_enemy_spawner_timer_timeout()
			queue_free()
			
	

func _physics_process(delta):
	if(health < 0):
		GUI.incScore(score)
		queue_free()
	
	if nav_target != null : # Do not use navigation unti a target is found
		
		navigation_agent.target_position = nav_target.position # Set the position of the target
		
		if navigation_agent.is_navigation_finished(): # Check if the destination is reached
			nav_target = null #Make the target null again
		
		else:
			# calculate velocity to reach the next point of the path
			var new_velocity = (navigation_agent.get_next_path_position() - global_position).normalized()
			
			look_at(navigation_agent.target_position)
			new_velocity = new_velocity * speed
			velocity = new_velocity
			move_and_slide()
	
	elif player:
		look_at(player.global_position)
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
		

func player_collision():
	
	if(player.armor_value == 0):
			player.health-=damageFactor
			
	queue_free()
	

func _on_area_2d_body_entered(body):
	
	if body.is_in_group("Player"):
		if(body.armor_value == 0):
			body.health-=damageFactor
		queue_free()
		
	elif body.is_in_group("Environment"):
		nav_target = player # set the navigation target as player
		
