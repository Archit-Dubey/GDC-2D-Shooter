extends CanvasLayer

var musicLevel = 0
var soundLevel = 0

@onready var mainMenu = $"../MainMenu"
@onready var soundSlider = $VBoxContainer2/SoundFXLabel/SoundSlider
@onready var musicSlider = $VBoxContainer2/MusicLabel/MusicSlider
@onready var joystickSettings = $JoystickSettings
@onready var joystick1 = $JoystickSettings/Joystick1
@onready var joystick2 = $JoystickSettings/Joystick2
@onready var weaponButton = $JoystickSettings/WeaponSelect

var checkPos = 0

var positions = [Vector2(0,0),Vector2(0,0),Vector2(0,0)]

func _ready():
	
	if FileAccess.file_exists("user://musicdata.save"):
		var file = FileAccess.open("user://musicdata.save", FileAccess.READ)
		musicLevel = file.get_var(musicLevel)
		AudioServer.set_bus_volume_db(2,musicLevel)
		musicSlider.value = musicLevel

		
		
	if FileAccess.file_exists("user://sounddata.save"):
		var file = FileAccess.open("user://sounddata.save", FileAccess.READ)
		soundLevel = file.get_var(soundLevel)
		AudioServer.set_bus_volume_db(1,soundLevel)
		soundSlider.value = soundLevel
		
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


func _on_main_menu_button_pressed():
	mainMenu.visible = true
	self.visible = false


func _on_reset_button_pressed():
	DirAccess.remove_absolute("user://userdata.save")
	DirAccess.remove_absolute("user://joystickdata.save")


func _on_joystick_button_pressed():
	joystickSettings.visible = true


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)
	var file = FileAccess.open("user://sounddata.save", FileAccess.WRITE)
	file.store_var(value)


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	var file = FileAccess.open("user://musicdata.save", FileAccess.WRITE)
	file.store_var(value)


func _on_joystick_1_button_down():
	checkPos = 1

func _on_joystick_1_button_up():
	checkPos = 0
	positions = [joystick1.position,weaponButton.position,joystick2.position]
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)

func _on_joystick_2_button_down():
	checkPos = 2

func _on_joystick_2_button_up():
	checkPos = 0
	positions = [joystick1.position,weaponButton.position,joystick2.position]
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)

func _on_weapon_select_button_down():
	checkPos = 3

func _on_weapon_select_button_up():
	checkPos = 0
	positions = [joystick1.position,weaponButton.position,joystick2.position]
	var file = FileAccess.open("user://joystickdata.save", FileAccess.WRITE)
	file.store_var(positions)
