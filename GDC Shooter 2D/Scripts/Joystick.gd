extends Node2D

@export var deadzone = 15
@export var aimStick=false
@export var maxLength = 50
@onready var knob=$Knob
@onready var button = $TouchScreenButton

var posVector: Vector2
var shoot=false # to tell if the gun should be fired

var pressing = false

func _ready():
	maxLength *= scale.x

func _physics_process(delta):
	

	
	if aimStick == true:
				shoot=false
	if pressing: 
		if (get_global_mouse_position()).distance_to(global_position) <= maxLength:# the knob is within the circle
			
			knob.global_position = get_global_mouse_position()
			
		else:# the knob is outside the circle
			var angle = global_position.angle_to_point(get_global_mouse_position())
			knob.global_position.x = global_position.x + cos(angle)*maxLength
			knob.global_position.y = global_position.y + sin(angle)*maxLength
			if aimStick == true:
				shoot=true #flag that the gun can be fired
		calculateVector()
	else:
		knob.global_position = lerp(knob.global_position, global_position, delta*50)
		posVector = Vector2(0,0)
		
func calculateVector():
	if abs((knob.global_position.x - global_position.x)) >= deadzone:
		posVector.x = (knob.global_position.x - global_position.x)/maxLength
	if abs((knob.global_position.y - global_position.y)) >= deadzone:
		posVector.y = (knob.global_position.y - global_position.y)/maxLength
		
func _on_touch_screen_button_pressed():
	print("Touching")
	pressing = true


func _on_touch_screen_button_released():
	pressing = false
