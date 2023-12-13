extends CanvasLayer

@onready var joystick1 = $Joystick1
@onready var joystick2 = $Joystick2
@onready var weaponButton = $WeaponSelect

var checkPos = 0

var lastPressed=null

var maxScale=2
var minScale=1
var scaleFactor=0.1

var positions = [Vector2(0,0),Vector2(0,0),Vector2(0,0),1,1,1] #also added scale to this

# Called when the node enters the scene tree for the first time.
func update_pos():
	positions = [joystick1.position,weaponButton.position,joystick2.position,
				joystick1.scale,weaponButton.scale,joystick2.scale]
	print(positions)
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)
	
func _ready():
	
	ResourceLoader.load_threaded_request("Scenes/JoystickSettings.tscn")
	
	if FileAccess.file_exists("user://joystickdata.save"):

		var file = FileAccess.open("user://joystickdata.save", FileAccess.READ)
		positions = file.get_var()
		joystick1.position = positions[0]
		weaponButton.position = positions[1]
		joystick2.position = positions[2]
		joystick1.scale=positions[3]
		weaponButton.scale=positions[4]
		joystick2.scale=positions[5]
		
	else:
		update_pos()
		

func _process(delta):
	if checkPos == 1:
		joystick1.position = joystick1.get_global_mouse_position() - joystick1.pivot_offset

	elif checkPos == 2:
		joystick2.position = joystick2.get_global_mouse_position() - joystick2.pivot_offset
		
	elif checkPos == 3:
		weaponButton.position = weaponButton.get_global_mouse_position() - weaponButton.pivot_offset
		

func _on_joystick_1_button_down():
	checkPos = 1
	lastPressed=1

func _on_joystick_1_button_up():
	update_pos()
	checkPos = 0
	

func _on_joystick_2_button_down():
	checkPos = 2
	lastPressed=2

func _on_joystick_2_button_up():
	update_pos()
	checkPos = 0

	

func _on_weapon_select_button_down():
	checkPos = 3
	lastPressed=3

func _on_weapon_select_button_up():
	update_pos()
	
	checkPos = 0
	


func _on_reset_button_pressed():
	checkPos = 0
	lastPressed=null
	DirAccess.remove_absolute("user://joystickdata.save")
	var joystickSettings = ResourceLoader.load_threaded_get("Scenes/JoystickSettings.tscn")
	get_parent().add_child(joystickSettings.instantiate())
	queue_free()


func _on_done_button_pressed():
	$"../OtherSettings".visible = true
	queue_free()


func _on_scale_up_pressed():
	if lastPressed==1:
		joystick1.scale=clamp(joystick1.scale+(Vector2.ONE*scaleFactor),Vector2.ONE*minScale,Vector2.ONE*maxScale)
	elif lastPressed==3:
		weaponButton.scale=clamp(weaponButton.scale+(Vector2.ONE*scaleFactor),Vector2.ONE*minScale,Vector2.ONE*maxScale)
	elif lastPressed==2:
		joystick2.scale=clamp(joystick2.scale+(Vector2.ONE*scaleFactor),Vector2.ONE*minScale,Vector2.ONE*maxScale)
	update_pos()


func _on_scale_down_pressed():
	if lastPressed==1:
		joystick1.scale=clamp(joystick1.scale-(Vector2.ONE*scaleFactor),Vector2.ONE*minScale,Vector2.ONE*maxScale)
	elif lastPressed==3:
		weaponButton.scale=clamp(weaponButton.scale-(Vector2.ONE*scaleFactor),Vector2.ONE*minScale,Vector2.ONE*maxScale)
	elif lastPressed==2:
		joystick2.scale=clamp(joystick2.scale-(Vector2.ONE*scaleFactor),Vector2.ONE*minScale,Vector2.ONE*maxScale)
	update_pos()
