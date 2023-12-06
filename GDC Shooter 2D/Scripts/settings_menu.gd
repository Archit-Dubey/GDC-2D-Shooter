extends CanvasLayer

var musicLevel = 0
var soundLevel = 0

@onready var mainMenu = $"../MainMenu"

@onready var soundSlider = $OtherSettings/VBoxContainer2/HBoxContainer/Sprite2D/SoundSlider
@onready var musicSlider = $OtherSettings/VBoxContainer2/HBoxContainer2/MusicSlider
@onready var joystickSettings = preload("res://Scenes/JoystickSettings.tscn")
@onready var soundSliderImage = $OtherSettings/VBoxContainer2/HBoxContainer/Sprite2D

@onready var volumeSlider0 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider0.png")
@onready var volumeSlider1 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider1.png")
@onready var volumeSlider2 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider2.png")
@onready var volumeSlider3 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider3.png")
@onready var volumeSlider4 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider4.png")

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
		

func _on_main_menu_button_pressed():
	mainMenu.visible = true
	self.visible = false


func _on_reset_button_pressed():
	DirAccess.remove_absolute("user://userdata.save")
	DirAccess.remove_absolute("user://joystickdata.save")


func _on_joystick_button_pressed():
	add_child(joystickSettings.instantiate())
	$OtherSettings.visible = false


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)
	var file = FileAccess.open("user://sounddata.save", FileAccess.WRITE)
	file.store_var(value)
	
	print(value)
	
	if(value <= 3):
		soundSliderImage.texture = volumeSlider0
	
	elif(value <= 30):
		soundSliderImage.texture = volumeSlider1
	
	elif(value <= 55):
		soundSliderImage.texture = volumeSlider2
	
	elif(value <= 80):
		soundSliderImage.texture = volumeSlider3
		
	elif(value <= 90):
		soundSliderImage.texture = volumeSlider4


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	var file = FileAccess.open("user://musicdata.save", FileAccess.WRITE)
	file.store_var(value)


