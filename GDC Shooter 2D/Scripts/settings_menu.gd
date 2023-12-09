extends CanvasLayer

var musicLevel = 0
var soundLevel = 0
var isInLevel=false

@onready var mainMenu = null
@onready var soundSlider = $OtherSettings/TopContainer/SoundContainer/SliderTexture/SoundSlider
@onready var musicSlider = $OtherSettings/TopContainer/MusicContainer/SliderTexture/MusicSlider
@onready var joystickSettings = preload("res://Scenes/JoystickSettings.tscn")
@onready var soundSliderImage = $OtherSettings/TopContainer/SoundContainer/SliderTexture
@onready var musicSliderImage = $OtherSettings/TopContainer/MusicContainer/SliderTexture

@onready var volumeSlider0 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider0.png")
@onready var volumeSlider1 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider1.png")
@onready var volumeSlider2 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider2.png")
@onready var volumeSlider3 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider3.png")
@onready var volumeSlider4 = preload("res://Assets/Art/UI/VolumeSlider/volumeSlider4.png")

func _ready():
	mainMenu=get_node_or_null("../MainMenu")
	if mainMenu== null:
		isInLevel=true
	if isInLevel:#if settings is opened in a level and not main menu
		
		$OtherSettings/BottomContainer/HBoxContainer/ResetButton.visible=false
		$OtherSettings/BottomContainer/MainMenuButton.text="Resume"
	
		
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
	
	if isInLevel:
		get_parent().visible=true#make pause screen visible
	else:
		mainMenu.visible = true
		
	self.visible = false


func _on_reset_button_pressed():
	DirAccess.remove_absolute("user://userdata.save")


func _on_joystick_button_pressed():
	
	add_child(joystickSettings.instantiate())
	$OtherSettings.visible = false


func changeTexture(imageName, value, max_value):
	
	if(value <= 0.03 * max_value):
		imageName.texture = volumeSlider0
	
	elif(value <= 0.3 * max_value):
		imageName.texture = volumeSlider1
	
	elif(value <= 0.55 * max_value):
		imageName.texture = volumeSlider2
	
	elif(value <= 0.8 * max_value):
		imageName.texture = volumeSlider3
		
	elif(value <= 0.9 * max_value):
		imageName.texture = volumeSlider4


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)
	var file = FileAccess.open("user://sounddata.save", FileAccess.WRITE)
	file.store_var(value)
	changeTexture(soundSliderImage, value, soundSlider.max_value)


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)
	var file = FileAccess.open("user://musicdata.save", FileAccess.WRITE)
	file.store_var(value)
	print(value)
	changeTexture(musicSliderImage, value, musicSlider.max_value)

