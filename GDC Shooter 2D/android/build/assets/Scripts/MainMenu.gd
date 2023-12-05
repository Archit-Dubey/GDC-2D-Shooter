extends CanvasLayer

var save_path = "user://userdata.save"

@onready var cam=$Camera2D
@onready var settingsMenu = $SettingsMenu
@onready var mainMenu = $MainMenu

@export var movespeed=100


func _ready():
	pass

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
