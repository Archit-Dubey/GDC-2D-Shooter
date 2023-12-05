extends Area2D 
#chose an area2d because it is very flexible and does not need
#to account for physics anf stuff

@export var damage=20 #set later
@export var speed=500 #speed of bullet

@onready var direction:Vector2


var destroy=false

func _ready():
	$AnimatedSprite2D.play("Idle")
	top_level=true



func _physics_process(delta):
	position+=direction.normalized()*speed*delta #manually moves bullet
	
func set_direction(dir:float): #converts rotation degrees into a vector2d
	direction=Vector2(cos(dir), sin(dir))
	
	


func _on_body_entered(body):
	
	
	if body.is_in_group("Enemy"):
		$AnimatedSprite2D.play("Hit")
		set_physics_process(false)
		body.health-=damage
		destroy=true
		
	if body.is_in_group("Environment"):
		$AnimatedSprite2D.play("Hit")
		set_physics_process(false)
		destroy=true


func _on_area_entered(area):
	
	
	if area.is_in_group("Enemy"):
		$AnimatedSprite2D.play("Hit")
		set_physics_process(false)
		area.health-=damage
		destroy=true





func _on_animated_sprite_2d_animation_finished():
	if destroy:
		queue_free()
