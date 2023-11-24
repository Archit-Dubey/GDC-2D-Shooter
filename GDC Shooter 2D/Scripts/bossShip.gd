extends Area2D


@onready var gunPiv=$GunPivot
@onready var player=$"../Player"
@onready var lazerRay=$GunPivot/RayCast2D
@onready var lazerBeam=$GunPivot/Lazer#the sprite

@export var damage=300 #damage is applied every frame
@export var lazerRange=2000
@export var health=1000
@export var shipTurnSpeed=0.1
@export var turretSpeed=8
@export var shipSpeed=50
var boundaryBoss=true

func _ready():
	gunPiv.top_level=true#makes movement of the gun independent of ship movement
	#this is needed to rotate the ship and gun independently
	gunPiv.scale=scale
	lazerRay.target_position.x=lazerRange
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	gunPiv.global_position=global_position #make the position the same
	
	gunPiv.rotation=lerp_angle(gunPiv.rotation, (player.global_position - gunPiv.global_position).normalized().angle(),turretSpeed*delta)
	
	if boundaryBoss:
		rotation=lerp_angle(rotation, (player.global_position - global_position).normalized().angle(),shipTurnSpeed*delta)
	
	

		global_position = global_position.move_toward(player.global_position,delta * shipSpeed)
		
		
		
		if lazerRay.is_colliding():
			lazerBeam.visible=true
			lazerBeam.position.x=249+lazerRange/2 #249 is the gun tip
			lazerBeam.scale.x=lazerRange
			lazerBeam.scale.y=15
			
			
			var obj=lazerRay.get_collider()
			if obj!=null and obj.is_in_group("Player"):
				obj.health-=damage*delta
			
		else:
			
			lazerBeam.visible=false
			lazerBeam.position.x=249
			lazerBeam.scale.x=1
			lazerBeam.scale.y=1
			





func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.instantKill()#instantly kills player
