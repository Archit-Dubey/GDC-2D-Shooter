extends Area2D 
#chose an area2d because it is very flexible and does not need
#to account for physics anf stuff

@export var damage=10 #set later
@export var speed=500 #speed of bullet

@onready var direction:Vector2

var destroy=false

func _ready():
	top_level=true



func _physics_process(delta):
	position+=direction.normalized()*speed*delta #manually moves bullet
	
func set_direction(dir:float): #converts rotation degrees into a vector2d
	direction=Vector2(cos(dir), sin(dir))
	
	


func _on_body_entered(body):
	if body.is_in_group("Player"):
		set_physics_process(false)
		$AnimatedSprite2D.play("Hit")
		destroy=true
		if(body.armor_value == 0):
			body.health-=damage
		
	elif body.is_in_group("Environment"):
		set_physics_process(false)
		$AnimatedSprite2D.play("Hit")
		destroy=true


func _on_animated_sprite_2d_animation_finished():
	if destroy:
		queue_free()
