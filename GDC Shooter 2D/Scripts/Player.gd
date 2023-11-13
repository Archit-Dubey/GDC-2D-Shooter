extends CharacterBody2D

@onready var joystick_direction = $"../CanvasLayer/Bottom_Left_Container/Joystick_Direction"
@onready var joystick_rotation = $"../CanvasLayer/Bottom_Right_Container/Joystick_Rotation"

@export var movingspeed = 300
@export var rotation_speed = 5 

func _physics_process(delta):
	var direction = joystick_direction.posVector
	if direction:
		velocity = direction * movingspeed
	else:
		velocity = Vector2(0,0)
		
	move_and_slide()
	
	var rotation_input = joystick_rotation.posVector

	if rotation_input.length() > 0.01:
		rotation = rotation_angle(velocity, rotation_input)
		rotate(rotation * rotation_speed * delta)

func rotation_angle(a: Vector2, b: Vector2) -> float:
	return atan2(b.y, b.x) - atan2(a.y, a.x)
