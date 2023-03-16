extends Node3D

var mouse_mov_x 
var sway_threshold = 5
var sway_lerp_x = 5

@export var sway_left : Vector3
@export var sway_right : Vector3
@export var sway_nor : Vector3

var mouse_mov_y
var sway_threshold_y = 5
var sway_lerp_y = 5

@export var sway_left_y : Vector3
@export var sway_right_y : Vector3
@export var sway_nor_y : Vector3

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov_x = -event.relative.x
		mouse_mov_y = -event.relative.y

func _process(delta):
	if mouse_mov_x != null:
		if mouse_mov_x > sway_threshold:
			rotation = rotation.lerp(sway_left,sway_lerp_x * delta)
		elif mouse_mov_x < -sway_threshold:
			rotation = rotation.lerp(sway_right,sway_lerp_x * delta)
		else:
			rotation = rotation.lerp(sway_nor,sway_lerp_x * delta)
			
	if mouse_mov_y != null:
		if mouse_mov_y > sway_threshold_y:
			rotation = rotation.lerp(sway_left_y,sway_lerp_y * delta)
		elif mouse_mov_y < -sway_threshold_y:
			rotation = rotation.lerp(sway_right_y,sway_lerp_y * delta)
		else:
			rotation = rotation.lerp(sway_nor_y,sway_lerp_y * delta)
