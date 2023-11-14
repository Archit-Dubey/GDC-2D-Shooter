extends CharacterBody2D

@onready var joystick_direction = $"../GUI/directionAnchor/Joystick_Direction" #movement joystick
@onready var joystick_rotation = $"../GUI/rotationAnchor/Joystick_Rotation" #aiming joystick
@onready var gun=$GunTip # the tip of the gun from which projectiles will be spawned
@onready var gunCoolDown=$gunCoolDownTimer # timer to cap fire rate
@onready var defaultBullet=preload("res://Scenes/defaultBullet.tscn") #basic bullet type
@onready var bulletType=defaultBullet # the current type of gun/bullet selected

@export var movingspeed = 300
@export var rotation_speed = 5 
@export var defaultFireRate=0.25 #no of seconds between each bullet



func _ready():
	
	gunCoolDown.wait_time=defaultFireRate

func _physics_process(delta):
	
	var direction = joystick_direction.posVector
	
	
	if direction:
		velocity = direction * movingspeed
		print(direction)
		print(velocity)
	else:
		velocity = Vector2(0,0)
		
		#remove from below before publishing
		#it is just for easier playtesting with keyboard in the future
		var debug_key_x=Input.get_action_raw_strength("right")-Input.get_action_raw_strength("left")
		var debug_key_y=Input.get_action_raw_strength("down")-Input.get_action_raw_strength("up")
		direction=Vector2(debug_key_x,debug_key_y)
		velocity = direction * movingspeed
		print(direction)
		print(velocity)
		#remove till above
		
		
		
	move_and_slide()
	
	var rotation_input = joystick_rotation.posVector
	var firePressed=joystick_rotation.shoot #checks if aim joystick goes out of limit
	
	if rotation_input.length() > 0.01:
		rotation = rotation_angle(velocity, rotation_input)
		print(rotation)
		rotate(rotation * rotation_speed * delta)
	
		
	if firePressed and gunCoolDown.is_stopped(): 
		#if joystick knob is outside and gun is ready to fire
		
		var newBullet=bulletType.instantiate()
		newBullet.global_position=gun.global_position
		newBullet.set_direction(rotation)
		gun.add_child(newBullet)
		gunCoolDown.start() 

func rotation_angle(a: Vector2, b: Vector2) -> float:
	return atan2(b.y, b.x) - atan2(a.y, a.x)


