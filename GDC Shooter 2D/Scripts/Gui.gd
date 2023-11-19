extends CanvasLayer

var save_path = "user://userdata.save"

@onready var health=$healthBar
@onready var lives=$lives
@onready var player=$"../Player"
@onready var scoreboard=$Score
@onready var highscore=$HighScore

var currScore=0
var currHighscore=0

func _ready():
	incScore(0)
	health.max_value=player.maxHealth #set the max to the players max health
	lives.text=str(player.lives)
	
	# Load high score from local storage
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		currHighscore = file.get_var(currHighscore)
		highscore.text = "High Score: " + str(currHighscore)
	else:
		print("No data saved")
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")

func _process(delta):
	pass

func updatePlayerHealth(num): #updates gui bar (does not affect player, this is just visual)
	health.value=num
	lives.text="Lives: "+str(player.lives)
	
func incScore(num):
	currScore+=num
	scoreboard.text="Score: "+str(currScore)
	if currScore > currHighscore:
		currHighscore = currScore
		save_high_score()
		highscore.text = "High Score: " + str(currHighscore)
	
# Save high score to local storage
func save_high_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(currHighscore)
