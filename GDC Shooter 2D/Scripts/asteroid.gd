extends StaticBody2D

@onready var spawner = $"../AsteroidSpawner"

@export var size =1
@export var spin=10

var once = true

func _ready():
	scale.x=scale.x*size
	scale.y=scale.y*size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation_degrees+=spin*delta
	
	#This one is what i have written for the collision problem
	#This basically allows each asteroid to detect collision with another only one time
	#Hence older asteroid that are placed will not be removed
	#And will not slow down the game as well
	#I did it this way because after implementing the code in _ready()
	#it still left out a few cases where there were overlapping
	if(once == true):
		var collision = move_and_collide(Vector2.ZERO)
		if collision:
			if collision.get_collider().is_in_group("Environment"):
				once = false
				#print("Still")
				spawner.create_asteroids()
				queue_free()
	#Here it ends
