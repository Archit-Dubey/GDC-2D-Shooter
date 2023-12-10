extends CanvasLayer

var save_path = "user://userdata.save"
var currInfo=0

@onready var cam=$Camera2D
@onready var settingsMenu = $SettingsMenu
@onready var mainMenu = $MainMenu
@onready var instructionScreen=$InstructionScreen
@export var movespeed=100



func _ready():
	$InstructionScreen/InfoPage3.visible=true
	$InstructionScreen/InfoPage3.visible=true
	$InstructionScreen/InfoPage3.visible=true
	$InstructionScreen.visible=false
	$MainMenu.visible=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	cam.position.x+=movespeed*delta
	cam.position.y+=movespeed*delta/2
	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	settingsMenu.visible = true
	mainMenu.visible = false


func _on_instructions_pressed():
	mainMenu.visible = false
	instructionScreen.visible=true
	$InstructionScreen/InfoPage1.visible=true
	$InstructionScreen/InfoPage2.visible=false
	$InstructionScreen/InfoPage3.visible=false
	

func _on_next_pressed():
	if currInfo==0:
		$InstructionScreen/InfoPage1.visible=false
		$InstructionScreen/InfoPage2.visible=true
		currInfo=1
	elif currInfo==1:
		$InstructionScreen/InfoPage2.visible=false
		$InstructionScreen/InfoPage3.visible=true
		currInfo=2
	elif currInfo==2:
		$InstructionScreen/InfoPage3.visible=false
		$InstructionScreen/InfoPage1.visible=true
		currInfo=0
	


func _on_back_to_menu_pressed():
	mainMenu.visible = true
	instructionScreen.visible=false
	$InstructionScreen/InfoPage1.visible=false
	$InstructionScreen/InfoPage2.visible=false
	$InstructionScreen/InfoPage3.visible=false
