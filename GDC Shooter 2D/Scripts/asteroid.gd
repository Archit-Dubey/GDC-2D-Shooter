extends Sprite2D


@export var size =1
@export var spin=10

func _ready():
	scale.x=scale.x*size
	scale.y=scale.y*size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation_degrees+=spin*delta
