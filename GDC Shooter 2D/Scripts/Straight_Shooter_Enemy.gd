extends Area2D

@export var speed = 100  # Adjust this value to control the speed of the enemy

@onready var player = $"/root/Main/Player"
@onready var gun = $GunTip
@onready var bullet = preload("res://Scenes/straight_shooter_bullet.tscn")

func _ready():
		pass

func _process(delta):
	if player:
		
		# Make the enemy look at player all the time
		look_at(player.global_position)

		global_position = global_position.move_toward(player.global_position,delta * speed)
		
	else:
		pass 

func _on_body_entered(body):
	print(body)
	if body.is_in_group("Player"):
		queue_free()
		

func _on_area_entered(area):
	
	if area.is_in_group("Player"):
		queue_free()

func _on_timer_timeout():
	var newBullet=bullet.instantiate()
	newBullet.global_position=gun.global_position
	newBullet.set_direction(rotation)
	newBullet.global_rotation_degrees = global_rotation_degrees
	gun.add_child(newBullet)
