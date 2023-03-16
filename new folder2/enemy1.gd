extends CharacterBody3D

var hp = 100

func _process(_delta):
	if hp <=0:
		queue_free()
