extends Node2D

@export var x_extents=1000
@export var y_extents=1000
@export var max_size=20
@export var min_size=5
@export var max_spin=20
@export var num=10
@export var asteroids: Array[PackedScene] = []
@export var minimum_gap=1000 #minimum gap between asteroids

@onready var level=$".."


var random = RandomNumberGenerator.new()
var placed=[]#array of already placed coordinates (to prevent overlap)		

func _ready():
	random.randomize()
	create_asteroids()


func possibleOverlap(x,y): # checks if new asteroid overlaps with old
	print("Possible Overlap")
	print(placed)
	for i in placed:
		var dist=sqrt( ((i[0]-x)**2)+((i[1]-y)**2) ) 
		if dist<minimum_gap:
			return true
		else:
			return false
		
		
#spawns asteroids randomly
func create_asteroids():
	
	for i in range(num):
		var xpos=random.randi_range(-x_extents,x_extents)
		var ypos=random.randi_range(-y_extents,y_extents)
		
		while true:
			if possibleOverlap(xpos,ypos):
				xpos=random.randi_range(-x_extents,x_extents)
				ypos=random.randi_range(-y_extents,y_extents)
			else:
				break
				
		placed.append([xpos,ypos])
				
		var a=asteroids[random.randi_range(0,len(asteroids)-1)].instantiate()
		a.global_position.x=xpos
		a.global_position.y=ypos
		a.size=random.randi_range(min_size,max_size)
		a.spin=random.randi_range(-max_spin,max_spin)
		level.call_deferred("add_child",a) #directly adding children sometimes causes slowdowns
