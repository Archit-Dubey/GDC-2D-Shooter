extends Area2D

@export var speed = 200  # Adjust this value to control the speed of the enemy
@onready var player=$"/root/Main/Player"

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
