extends Area2D

@export var maxRange=1000 #max range to start firing
@export var stopRange=100#to stop chasing
@export var bulletDamage=10
@export var speed = 100  # Adjust this value to control the speed of the enemy
@export var health=20#health of the enemy
@export var score=100#score increase on death

@onready var player = $"../../Player"
@onready var gun = $GunTip
@onready var GUI=$"../../GUI"
@onready var bullet = preload("res://Scenes/straight_shooter_bullet.tscn")


func _ready():
		pass

func _physics_process(delta):
	if health<0:
		GUI.incScore(score)
		queue_free()
	if player:
		
		# Make the enemy look at player all the time
		look_at(player.global_position)
		if global_position.distance_to(player.global_position)>stopRange:
			global_position = global_position.move_toward(player.global_position,delta * speed)
		else:
			global_position = global_position.move_toward(-player.global_position,delta *speed)
	else:
		pass 

func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		if(body.armor_value == 0):
			body.health=bulletDamage/2
		queue_free()

func _on_timer_timeout():
	if global_position.distance_to(player.global_position)<maxRange:
		var newBullet=bullet.instantiate()
		newBullet.global_position=gun.global_position
		newBullet.set_direction(rotation)
		newBullet.damage=bulletDamage
		newBullet.global_rotation_degrees = global_rotation_degrees
		gun.add_child(newBullet)
