extends CharacterBody3D

var speed 
var Default_speed = 5.0
var sprint_speed = 10.0
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1
@onready var accel = ACCEL_DEFAULT
var gravity = 9.8
const JUMP_VELOCITY = 4.65

var d_height = 1.6
var crouch_height = 1.2

var crouch_speed = 20

var mouse_sense = 0.11
var snap

var direction = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var pcap = $CollisionShape3D
@onready var ray = $RayCast3D

func _ready():
	#hides the cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get keyboard input
	var raying = false
	speed = Default_speed
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("s") - Input.get_action_strength("w")
	var h_input = Input.get_action_strength("d") - Input.get_action_strength("a")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	#jumping and gravity
	if not is_on_floor():
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		velocity.y -= gravity * delta
	else:
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		velocity.y -= JUMP_VELOCITY 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		snap = Vector3.ZERO
		accel = ACCEL_AIR
		velocity.y = JUMP_VELOCITY 
	#make it move
	velocity = velocity.lerp(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	move_and_slide()
	# crouch func
	if ray.is_colliding():
		raying = true
	if raying:
		pcap.shape.height -= crouch_speed * delta
	elif not raying:
		pcap.shape.height += crouch_speed * delta
	pcap.shape.height =  clamp(pcap.shape.height, crouch_height,d_height)
	if Input.is_action_pressed("crouch"):
		speed = Default_speed
		pcap.shape.height -= crouch_speed * delta
	elif not raying:
		pcap.shape.height += crouch_speed * delta
	pcap.shape.height =  clamp(pcap.shape.height, crouch_height,d_height)
