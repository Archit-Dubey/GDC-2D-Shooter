extends Area2D
@export var health=20
@export var damageFactor=20
@export var score=100#score increase on death
@export var speed = 200  # Adjust this value to control the speed of the enemy
@onready var GUI=$"../../GUI"
@onready var player=$"../../Player"
@onready var spawner=$"../.."



func _ready():
	var collision = get_overlapping_bodies()
	if collision:
		print(collision)
		if collision[0].get_collider().is_in_group("Environment"):
			spawner._on_powerups_spawner_timer_timeout()
			queue_free()

func _process(delta):
	if health<0:
		GUI.incScore(score)
		queue_free()
		
	if player:
		# Make the enemy look at player all the time
		look_at(player.global_position)

		global_position = global_position.move_toward(player.global_position,delta * speed)
		
	else:
		pass 

func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		if(body.armor_value == 0):
			body.health-=damageFactor
		queue_free()
	

