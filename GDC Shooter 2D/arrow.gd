extends Area2D

var target = null

@onready var navigation_agent = $NavigationAgent2D
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Arrows will always look at their target and will remain at the border of the screen
	# Due to contraint of not being able to navigate outside navigation area layer 8
	if target != null:
		navigation_agent.target_position = target.global_position
		var next_path = navigation_agent.get_next_path_position()
		var new_velocity = (next_path - global_position)
		look_at(target.global_position)
		global_position = next_path
		
	else:
		pass
		
