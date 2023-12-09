extends CanvasLayer

var save_path = "user://userdata.save"

@onready var health=$healthBar
@onready var lives=$lives
@onready var player=$"../Player"
@onready var scoreboard=$Score
@onready var highscore=$HighScore
@onready var pauseAnim=$PauseScreen/PauseAnim
@onready var deathAnim=$DeathScreen/DeathAnim
@onready var weaponSelect=$WeaponSelect
@onready var settingsMenu=$SettingsMenu
@onready var weaponTypes=[
	[true,"None",0],#noweapon #ALWAYS make sure that atleast one of them is true
	[false,"default",1],#allowed, name/image of weapon, weapon code
	[false,"strong",2]
]

var currScore=0
var currHighscore=0
var currWeapon=0

func _ready():
	
	settingsMenu.visible=false
	weaponSelect.text=weaponTypes[currWeapon][1]
	incScore(0)
	health.max_value=player.maxHealth #set the max to the players max health
	lives.text="Lives: "+str(player.lives)
	
	# Load high score from local storage
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		currHighscore = file.get_var(currHighscore)
		highscore.text = "High Score: " + str(currHighscore)
	else:
		print("No data saved")
		
	set_joystick()


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")

func set_joystick():
	if FileAccess.file_exists("user://joystickdata.save"):
		var file = FileAccess.open("user://joystickdata.save", FileAccess.READ)
		var positions = file.get_var()
		$joystick_left.global_position = positions[0]
		$joystick_right.global_position = positions[2]
		$WeaponSelect.global_position = positions[1]
		$joystick_left.scale=positions[3]
		$WeaponSelect.scale=positions[4]
		$joystick_right.scale=positions[5]

func _process(delta):
	
	pass
	

func updatePlayerHealth(num): #updates gui bar (does not affect player, this is just visual)
	health.value=num
	lives.text="Lives: "+str(player.lives)
	
func incScore(num):
	currScore+=num
	scoreboard.text="Score: "+str(currScore)
	
	save_high_score() #moved checking logic to function
		
	
# Save high score to local storage
func save_high_score():
	
	if currScore > currHighscore: 
		currHighscore = currScore
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(currHighscore)
		
		highscore.text = "High Score: " + str(currHighscore)

func _on_pause_pressed():
	$PauseScreen.visible = true
	get_tree().paused = true
	pauseAnim.play("Pause")
	_toggle_visibility_to(false)


func _on_resume_pressed():
	set_joystick()
	pauseAnim.play_backwards("Pause")
	_toggle_visibility_to(true)


func _on_menu_pressed():
	set_joystick()
	save_high_score()
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_quit_pressed():
	set_joystick()
	save_high_score()
	get_tree().quit()

func _toggle_visibility_to(value : bool):
	set_joystick()
	$Pause.visible = value
	$WeaponSelect.visible = value
	$joystick_left.visible = value
	$joystick_right.visible = value


func _on_retry_pressed():
	get_tree().reload_current_scene()

func showDeathScreen():
	$DeathScreen.visible=true
	deathAnim.play("Pause")
	_toggle_visibility_to(false)


func _on_weapon_select_pressed():
	var next=(currWeapon+1)%len(weaponTypes)
	
	while true:
		if weaponTypes[next][0]==true:
			currWeapon=next
			player.setWeaponType(weaponTypes[currWeapon][2])
			weaponSelect.text=weaponTypes[currWeapon][1]
			break
		else:
			next=(next+1)%len(weaponTypes)

func allowWeapon(index):
	weaponTypes[index][0]=true


func _on_pause_anim_animation_finished(anim_name):
	if $Pause.visible == true:
		$PauseScreen.visible = false
		get_tree().paused = false
	
	


func _on_settings_pressed():
	
	settingsMenu.visible = true
	visible=false

	
