extends CanvasLayer

@onready var joystick1 = $Joystick1
@onready var joystick2 = $Joystick2
@onready var weaponButton = $WeaponSelect
@onready var joystickSettings = preload("res://joystick_settings.tscn")

var checkPos = 0

var positions = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("user://joystickdata.save"):

		var file = FileAccess.open("user://joystickdata.save", FileAccess.READ)
		positions = file.get_var()
		joystick1.position = positions[0]
		weaponButton.position = positions[1]
		joystick2.position = positions[2]


func _process(delta):
	if checkPos == 1:
		joystick1.position = joystick1.get_global_mouse_position()
	
	elif checkPos == 2:
		joystick2.position = joystick2.get_global_mouse_position()
		
	elif checkPos == 3:
		weaponButton.position = weaponButton.get_global_mouse_position()
		

func _on_joystick_1_button_down():
	checkPos = 1

func _on_joystick_1_button_up():
	positions = [joystick1.position,weaponButton.position,joystick2.position]
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)
	checkPos = 0
	

func _on_joystick_2_button_down():
	checkPos = 2

func _on_joystick_2_button_up():
	positions = [joystick1.position,weaponButton.position,joystick2.position]
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)
	checkPos = 0
	

func _on_weapon_select_button_down():
	checkPos = 3

func _on_weapon_select_button_up():
	positions = [joystick1.position,weaponButton.position,joystick2.position]
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)
	checkPos = 0
	


func _on_reset_button_pressed():
	DirAccess.remove_absolute("user://joystickdata.save")
	joystickSettings.instantiate()
	get_parent().add_child(joystickSettings.instantiate())
	queue_free()


func _on_done_button_pressed():
	$"../OtherSettings".visible = true
	queue_free()