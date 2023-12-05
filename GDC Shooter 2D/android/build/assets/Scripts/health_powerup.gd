extends Area2D

@onready var arrow = preload("res://arrow.tscn")

@onready var player=$"../../Player"
@onready var main= $"../.."

var spawned_arrow = null

func _ready(): 
	add_arrow() # add a navigation arrow on spawning


func _process(_delta):
	pass

func _on_body_entered(body):
	if(body.is_in_group("Player")):
		body.health = body.maxHealth
		body.powerupSound.play()
		queue_free()
	
	#Temporary solution to the problem of asteroid and powerup overlapping
	elif(body.is_in_group("Environment")):
		queue_free()
		main.spawn_powerup=true
	
func add_arrow(): # Add a navigation arrow
	spawned_arrow = arrow.instantiate()
	spawned_arrow.global_position = player.global_position
	spawned_arrow.target = self
	main.add_child(spawned_arrow)

func remove_arrow(): # remove the navigation arrow
	spawned_arrow.queue_free()
	spawned_arrow = null

func _on_visible_on_screen_notifier_2d_screen_entered(): # if powerup is visible in screen
	if spawned_arrow != null:
		remove_arrow()


func _on_visible_on_screen_notifier_2d_screen_exited(): # if powerup is not visible in screen
	add_arrow()
		
