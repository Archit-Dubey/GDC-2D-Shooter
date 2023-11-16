extends Area2D
@export var health=20
@export var damageFactor=20
@export var speed = 200  # Adjust this value to control the speed of the enemy
@onready var player=$"../../Player"

func _ready():
	pass

func _process(delta):
	if health<0:
		queue_free()
	if player:
		
		# Make the enemy look at player all the time
		look_at(player.global_position)

		global_position = global_position.move_toward(player.global_position,delta * speed)
		
	else:
		pass 

func _on_body_entered(body):
	
	if body.is_in_group("Player"):
		body.health-=damageFactor
		queue_free()
		
