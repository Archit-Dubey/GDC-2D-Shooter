extends CharacterBody2D

@export var maxRange=1000 #max range to start firing
@export var stopRange=100#to stop chasing
@export var bulletDamage=10
@export var speed = 100  # Adjust this value to control the speed of the enemy
@export var health=20#health of the enemy
@export var score=100#score increase on death

@onready var sprite=$AnimatedSprite2D
@onready var navigation_agent = $NavigationAgent2D
@onready var player = $"../../Player"
@onready var gun1 = $GunTip
@onready var gun2 = $GunTip2
@onready var GUI=$"../../GUI"
@onready var bullet = preload("res://Scenes/straight_shooter_bullet.tscn")
@onready var spawner=$"../.."
@onready var deathSound=$death
@onready var fireSound=$fireSound

var nav_target = null # The target of every navigation
var destroy=false

func _ready():
	
	var collision = move_and_collide(Vector2.ZERO)
	if collision:
		if collision.get_collider().is_in_group("Environment"):
			spawner._on_enemy_spawner_timer_timeout()
			queue_free()
	
			

func _physics_process(_delta):
	if health<=0:
		GUI.incScore(score)
		deathSound.play()
		
		sprite.play("Death")
		destroy=true
		set_physics_process(false)
		
	if nav_target != null : # Do not use navigation unti a target is found
		
		navigation_agent.target_position = nav_target.position # Set the position of the target
		
		if navigation_agent.is_navigation_finished(): # Check if the destination is reached
			nav_target = null #Make the target null again
		
		else:
			# calculate velocity to reach the next point of the path
			var new_velocity = (navigation_agent.get_next_path_position() - global_position).normalized()
			
			look_at(navigation_agent.target_position)
			
			if global_position.distance_to(player.global_position)>stopRange:
				velocity = new_velocity * speed
				move_and_slide()
			else:
				velocity = -new_velocity * speed
				move_and_slide()
	
	elif player:
		look_at(player.global_position)
		var dir = (player.global_position - global_position).normalized()
		if global_position.distance_to(player.global_position)>stopRange:
			velocity = dir * speed
			move_and_slide()
		else:
			velocity = -dir * speed
			move_and_slide()
	
	


func _on_timer_timeout():
	if global_position.distance_to(player.global_position)<maxRange:
		fireSound.play()
		var newBullet=bullet.instantiate()
		newBullet.global_position=gun1.global_position
		newBullet.set_direction(rotation)
		newBullet.damage=bulletDamage
		newBullet.global_rotation_degrees = global_rotation_degrees
		gun1.add_child(newBullet)
		newBullet=bullet.instantiate()
		newBullet.global_position=gun2.global_position
		newBullet.set_direction(rotation)
		newBullet.damage=bulletDamage
		newBullet.global_rotation_degrees = global_rotation_degrees
		gun2.add_child(newBullet)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if(body.armor_value == 0):
			body.health-=bulletDamage*2
		health = -1
		
		
	elif body.is_in_group("Environment"):
		nav_target = player # set the navigation target as player



func _on_animated_sprite_2d_animation_finished():
	if destroy:
		queue_free()
