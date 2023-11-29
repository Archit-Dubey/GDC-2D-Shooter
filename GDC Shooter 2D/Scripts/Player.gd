extends CharacterBody2D


@onready var joystick_direction = $"../GUI/directionAnchor/Joystick_Direction" #movement joystick
@onready var joystick_rotation = $"../GUI/rotationAnchor/Joystick_Rotation" #aiming joystick
@onready var gun=$GunTip # the tip of the gun from which projectiles will be spawned
@onready var gunCoolDown=$gunCoolDownTimer # timer to cap fire rate
@onready var defaultBullet=preload("res://Scenes/defaultBullet.tscn") #basic bullet type
@onready var bulletType=defaultBullet # the current type of gun/bullet selected
@onready var gui=$"../GUI"
@onready var powerupTimerContainer = $powerupTimerContainer
@onready var deathSound=$death
@onready var fireSound=$fireSound
@onready var powerupSound=$powerup

@export var maxMovespeed=300#to cap the speed when speed powerup is picked up
@export var movingspeed = 300
@export var rotation_speed = 5 
@export var defaultFireRate=0.25 #no of seconds between each bullet
@export var maxHealth=100
@export var maxLives = 3
@export var lives = 3
@export var armor_value = 0
@export var armor_duration = 10
@export var boost_duration = 10

var powerup_timer : Timer
var health = maxHealth#current health

func _ready():
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
			fireSound.play()
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
			deathSound.play()
			$AnimatedSprite2D.play("Death")
			$animTimer.start()
			set_physics_process(false)#stops this
	
func rotation_angle(rotation_vector: Vector2) -> float: 
	#modified function to calculate angle from a given vector, previous one was buggy
	return atan2(rotation_vector.y, rotation_vector.x)
	

func create_timer(function_name, duration):
	
	powerup_timer = Timer.new()
	powerupTimerContainer.add_child(powerup_timer)
	# To connect the function to the latest added child
	powerup_timer.connect("timeout", function_name)
	powerup_timer.start(duration)

func activate_armor():
	powerupSound.play()
	# We need to add some animation to signify there is an armor
	create_timer(_on_armor_timer_timeout, armor_duration)
	armor_value += 1
	print("Armor Start")
	
func activate_speedBoost():
	powerupSound.play()
	# We need to add some animation to signify there is speed boost
	create_timer(_on_boost_timer_timeout, boost_duration)
	movingspeed = maxMovespeed * 2
	print("Speed Start")

func _on_armor_timer_timeout():
	armor_value -= 1
	powerupTimerContainer.remove_child(powerupTimerContainer.get_children()[0])
	print("Armor End")
	
func _on_boost_timer_timeout():
	movingspeed = maxMovespeed
	#deleting the first new child added to container
	powerupTimerContainer.remove_child(powerupTimerContainer.get_children()[0])
	print("Speed End")

func instantKill():
	health=0
	lives=0
	


func _on_anim_timer_timeout():
	print("pausing game,player died")
	get_tree().paused=true


func _on_bounds_body_exited(body): # removes enemies that are too far away
	if body.is_in_group("Enemy"):
		body.queue_free()



func _on_bounds_area_exited(area):
	if area.is_in_group("EnemyBullet"):
		area.queue_free()
	elif area.is_in_group("PlayerBullet"):
		area.queue_free()
