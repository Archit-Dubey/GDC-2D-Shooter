extends CharacterBody2D


@onready var gun=$GunTip # the tip of the gun from which projectiles will be spawned
@onready var gunCoolDown=$gunCoolDownTimer # timer to cap fire rate
@onready var defaultBullet=preload("res://Scenes/defaultBullet.tscn") #basic bullet type
@onready var strongBullet=preload("res://Scenes/strongBullet.tscn")
@onready var bulletType=0 # the current type of gun/bullet selected
@onready var gui=$"../GUI"
@onready var powerupTimerContainer = $powerupTimerContainer
@onready var deathSound=$death
@onready var fireSound=$fireSound
@onready var powerupSound=$powerup
@onready var joystick_right = $"../GUI/joystick_right"
@onready var joystick_left = $"../GUI/joystick_left"

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


@onready var weaponStats=[ #the gui is responsible for controlling which weapon the player has
	[null,0],#noWeapon
	[defaultBullet,defaultFireRate],#default gun
	[strongBullet,defaultFireRate*2],#Slow and Strong Gun
]

var powerup_timer : Timer
var health = maxHealth#current health
var speed_count = 0 # To check if additional speed powerup was collected



func _ready():
	gunCoolDown.wait_time=weaponStats[bulletType][1]


func _physics_process(delta):
	gui.updatePlayerHealth(health)
	
	if health>0:
		
		var direction = Vector2(Input.get_axis("ui_left", "ui_right"),Input.get_axis("ui_up", "ui_down"))
		
		if direction != Vector2(0,0):
			
			# To make the player motion smoother with joystick
			velocity += direction * movingspeed * delta
			
		else:
			velocity = Vector2(0,0)
			#remove from below before publishing
			#it is just for easier playtesting with keyboard in the future
			var debug_key_x=Input.get_action_raw_strength("right")-Input.get_action_raw_strength("left")
			var debug_key_y=Input.get_action_raw_strength("down")-Input.get_action_raw_strength("up")
			direction=Vector2(debug_key_x,debug_key_y)
			velocity = direction.normalized() * movingspeed
			#remove till above
		
		velocity = velocity.limit_length(movingspeed)
		move_and_slide()
		
		var firePressed=joystick_right.shoot #checks if aim joystick goes out of limit


		if joystick_right and joystick_right.is_pressed:
			rotation = joystick_right.output.angle()

			
		if firePressed and gunCoolDown.is_stopped(): 
			#if joystick knob is outside and gun is ready to fire
			var currBullet=weaponStats[bulletType][0]
			if currBullet!=null:
				fireSound.play()
				var newBullet=currBullet.instantiate()
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
	speed_count += 1
	print("Speed Start")

func _on_armor_timer_timeout():
	armor_value -= 1
	powerupTimerContainer.remove_child(powerupTimerContainer.get_children()[0])
	print("Armor End")
	
func _on_boost_timer_timeout():
	speed_count -= 1
	if(speed_count == 0): # To only decrease speed if there's no additional powerup taken
		movingspeed = maxMovespeed
	#deleting the first new child added to container
	powerupTimerContainer.remove_child(powerupTimerContainer.get_children()[0])
	print("Speed End")

func instantKill():
	health=0
	lives=0
	

func _on_anim_timer_timeout():
	gui.showDeathScreen()
	

func _on_bounds_body_exited(body): # removes enemies that are too far away
	if body.is_in_group("Enemy"):
		body.queue_free()

func _on_bounds_area_exited(area):
	if area.is_in_group("EnemyBullet"):
		area.queue_free()
	elif area.is_in_group("PlayerBullet"):
		area.queue_free()

func setWeaponType(val:int):
	bulletType=val
	gunCoolDown.wait_time=weaponStats[bulletType][1]
