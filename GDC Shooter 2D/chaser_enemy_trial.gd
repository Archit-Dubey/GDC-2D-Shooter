extends CharacterBody2D

@export var health=20
@export var damageFactor=20
@export var score=100#score increase on death
@export var speed = 200  # Adjust this value to control the speed of the enemy

@onready var navigation_agent = $NavigationAgent2D
@onready var timer = $Timer

@onready var sprite=$AnimatedSprite2D
@onready var GUI=$"../../GUI"
@onready var player=$"../../Player"
@onready var spawner=$"../.."

var nav_target = null # The target of every navigation
var next_path = null
var destroy=false

func _ready():
	
	var collision = move_and_collide(Vector2.ZERO)
	if collision:
		if collision.get_collider().is_in_group("Environment"):
			spawner._on_enemy_spawner_timer_timeout()
			queue_free()



func _physics_process(delta):
	if(health < 0):
		GUI.incScore(score)
		
		$death.play()
		sprite.play("Death")
		destroy=true
		set_physics_process(false)
	
	if nav_target != null : # Do not use navigation unti a target is found
		
		if navigation_agent.is_navigation_finished(): # Check if the destination is reached	
			nav_target = null #Make the target null again
			timer.stop()
	
	elif player:
		look_at(player.global_position)
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
	
	move_and_slide()
		

func player_collision():
	
	if(player.armor_value == 0):
			player.health-=damageFactor
	
	sprite.play("Death")
	
	$death.play()
	destroy=true
	

func _on_area_2d_body_entered(body):
	
	if body.is_in_group("Player"):
		if(body.armor_value == 0):
			body.health-=damageFactor
		sprite.play("Death")
		
		$death.play()
		destroy=true
		set_physics_process(false)
		
	elif body.is_in_group("Environment"):
		nav_target = player # set the navigation target as player
		timer.start()
		_on_timer_timeout()
		

func _on_timer_timeout():
	
	navigation_agent.target_position = nav_target.position
					
	# calculate velocity to reach the next point of the path
	next_path = navigation_agent.get_next_path_position()
	var new_velocity = (next_path - global_position).normalized()
	look_at(next_path)
	new_velocity = new_velocity * speed
	velocity = new_velocity





func _on_animated_sprite_2d_animation_finished():
	if destroy:
		queue_free()
