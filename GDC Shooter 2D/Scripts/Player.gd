extends CharacterBody2D


@onready var joystick_direction = $"../GUI/directionAnchor/Joystick_Direction" #movement joystick
@onready var joystick_rotation = $"../GUI/rotationAnchor/Joystick_Rotation" #aiming joystick
@onready var gun=$GunTip # the tip of the gun from which projectiles will be spawned
@onready var gunCoolDown=$gunCoolDownTimer # timer to cap fire rate
@onready var defaultBullet=preload("res://Scenes/defaultBullet.tscn") #basic bullet type
@onready var bulletType=defaultBullet # the current type of gun/bullet selected
@onready var gui=$"../GUI"
@export var movingspeed = 300
@export var rotation_speed = 5 
@export var defaultFireRate=0.25 #no of seconds between each bullet
@export var maxHealth=100
var health = 100#current health
@export var lives = 1



func _ready():
	health=maxHealth
	gunCoolDown.wait_time=defaultFireRate

func _physics_process(delta):
	gui.updatePlayerHealth(health)
	if health>0:
		var direction = joystick_direction.posVector
		
		
		if direction:
			velocity = direction * movingspeed
			
		else:
			velocity = Vector2(0,0)
			
			#remove from below before publishing
			#it is just for easier playtesting with keyboard in the future
			var debug_key_x=Input.get_action_raw_strength("right")-Input.get_action_raw_strength("left")
			var debug_key_y=Input.get_action_raw_strength("down")-Input.get_action_raw_strength("up")
			direction=Vector2(debug_key_x,debug_key_y)
			velocity = direction.normalized() * movingspeed
			
			#remove till above
			
			
		move_and_slide()
		var rotation_input = joystick_rotation.posVector
		var firePressed=joystick_rotation.shoot #checks if aim joystick goes out of limit
		
		if rotation_input.length() > 0.01:
			rotation=rotation_angle(rotation_input)
			rotate(rotation * rotation_speed * delta)
		
			
		if firePressed and gunCoolDown.is_stopped(): 
			#if joystick knob is outside and gun is ready to fire
			
			var newBullet=bulletType.instantiate()
			newBullet.global_position=gun.global_position
			newBullet.set_direction(rotation)
			newBullet.global_rotation_degrees = global_rotation_degrees
			gun.add_child(newBullet)
			gunCoolDown.start()
	else:#put explosion animation here
		if lives>0:
			print("new life")
			health=maxHealth
			lives-=1
		else:
			print("died")
	
	
		

func rotation_angle(rotation_vector: Vector2) -> float: 
	#modified function to calculate angle from a given vector, previous one was buggy
	return atan2(rotation_vector.y, rotation_vector.x)
	


