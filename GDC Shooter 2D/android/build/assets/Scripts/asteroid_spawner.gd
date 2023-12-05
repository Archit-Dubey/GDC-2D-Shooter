extends Node2D

@export var x_extents=1000
@export var y_extents=1000
@export var max_size=20
@export var min_size=5
@export var max_spin=20
@export var num=10
@export var asteroids: Array[PackedScene] = []

var random = RandomNumberGenerator.new()
var placed=[]#array of already placed coordinates (to prevent overlap)		

var count = 0

func _ready():
	random.randomize()
	
	for i in range(num):
		create_asteroids()

# You can delete this function and delete the line that I have highlighted in asteroid.gd 
# if all bugs are solved in the commented one in this script
# But I can gurantee this method works perfectly
func create_asteroids():
	var xpos=random.randi_range(-x_extents,x_extents)
	var ypos=random.randi_range(-y_extents,y_extents)
	
	
	var a=asteroids[0].instantiate()
	a.global_position.x=xpos
	a.global_position.y=ypos
	a.size=random.randi_range(min_size,max_size)
	a.spin=random.randi_range(-max_spin,max_spin)
	a.add_to_group("Environment")
	call_deferred("add_child",a)
	

