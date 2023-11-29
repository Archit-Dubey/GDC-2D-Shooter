extends Area2D

@onready var main= get_parent().get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		body.health = body.maxHealth
		body.powerupSound.play()
		queue_free()
	
	#Temporary solution to the problem of asteroid and powerup overlapping
	elif(body.is_in_group("Environment")):
		queue_free()
		main.spawn_powerup=true
	
	
