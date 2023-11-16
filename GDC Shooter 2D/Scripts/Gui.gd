extends CanvasLayer


@onready var health=$healthBar
@onready var lives=$lives
@onready var player=$"../Player"
func _ready():
	health.max_value=player.maxHealth #set the max to the players max health
	lives.text=str(player.lives)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updatePlayerHealth(num): #updates gui bar (does not affect player, this is just visual)
	health.value=num
	lives.text=str(player.lives)
	
