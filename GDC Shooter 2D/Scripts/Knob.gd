extends Sprite2D

@export var aimStick=false
@export var maxLength = 50

@onready var parent = $".."

var deadzone = 15
var pressing = false

func _ready():
	deadzone = parent.deadzone
	maxLength *= parent.scale.x

func _physics_process(delta):
	if pressing: 
		if get_global_mouse_position().distance_to(parent.global_position) <= maxLength:# the knob is within the circle
			global_position = get_global_mouse_position()
		else:# the knob is outside the circle
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle)*maxLength
			global_position.y = parent.global_position.y + sin(angle)*maxLength
			print("outside")
		calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, delta*50)
		parent.posVector = Vector2(0,0)
		
func calculateVector():
	if abs((global_position.x - parent.global_position.x)) >= deadzone:
		parent.posVector.x = (global_position.x - parent.global_position.x)/maxLength
	if abs((global_position.y - parent.global_position.y)) >= deadzone:
		parent.posVector.y = (global_position.y - parent.global_position.y)/maxLength
		
func _on_button_button_down():
	pressing = true


func _on_button_button_up():
	pressing = false
