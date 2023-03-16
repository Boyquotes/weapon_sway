extends Node3D

@export var damage : int

@export var ammo : int
@export var max_ammo : int
@export var spare_ammo :int 

@export var ammo_per_shot : int 
@export var inf_spare_ammo : bool

@export var full_auto : bool

@export var reload_time : float
@export var firerate : float

@export var rayCast : NodePath
@onready var raycast = get_node(rayCast)

var can_shoot = true
var reloading = false
var paused = false


func _ready():
	randomize()

func _process(_delta):
	if ammo <= 0:
		can_shoot = false
	if Input.is_action_just_pressed("R") && reloading == false && paused == false:
		reload()
	if Input.is_action_pressed("fire") && can_shoot == true && full_auto == true && paused == false:
		fire()
	elif Input.is_action_just_pressed("fire") && can_shoot == true && full_auto == false && paused == false:
		fire()


func fire():
	can_shoot = false
	ammo -= ammo_per_shot
	if raycast.get_collider() != null && raycast.get_collider().is_in_group("enemy"):
		raycast.get_collider().hp -= damage
	if $AnimationPlayer != null:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("shoot")
	await get_tree().create_timer(firerate).timeout
	if reloading == false:
		can_shoot = true


func reload():
	reloading = true
	can_shoot = false
	if $AnimationPlayer != null:
		$AnimationPlayer.play("reload")
	await get_tree().create_timer(reload_time).timeout
	if inf_spare_ammo == false:
		var tmp_ammo
		if spare_ammo < max_ammo:
			tmp_ammo = ammo + spare_ammo
			if max_ammo - tmp_ammo >= 0:
				ammo += spare_ammo
				spare_ammo = 0
			else:
				ammo += spare_ammo
				ammo += max_ammo - tmp_ammo
				spare_ammo = -(max_ammo - tmp_ammo)
		else:
			spare_ammo -= max_ammo - ammo
			ammo = max_ammo
	else:
		ammo = max_ammo
	if ammo > 0:
		can_shoot = true
	reloading = false
