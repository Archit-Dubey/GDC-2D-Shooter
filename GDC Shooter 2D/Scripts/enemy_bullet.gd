extends Area2D 
#chose an area2d because it is very flexible and does not need
#to account for physics anf stuff

@export var damage=10 #set later
@export var speed=500 #speed of bullet

@onready var direction:Vector2

func _ready():
	top_level=true



func _physics_process(delta):
	position+=direction.normalized()*speed*delta #manually moves bullet
	
func set_direction(dir:float): #converts rotation degrees into a vector2d
	direction=Vector2(cos(dir), sin(dir))
	
	


func _on_body_entered(body):
	if body.is_in_group("Player"):
		if(body.armor_value == 0):
			body.health-=damage
		queue_free()
	elif body.is_in_group("Environment"):
		queue_free()
