extends CharacterBody2D


@export var speed = 200  # Adjust this value to control the speed of the enemy
@onready var player=$"/root/Main/Player"

func _ready():
		# Start moving towards the player
	if player:
		print("Yes")
	else:
		print("No")

func _process(delta):
	if player:
		# Calculate the direction to the player
		var direction = (player.global_position - global_position).normalized()

		# Move the enemy towards the player
		velocity = direction * speed
		
		# Make the enemy look at player all the time
		look_at(player.global_position)

		move_and_slide()
		
	else:
		print()


