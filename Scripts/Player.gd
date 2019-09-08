extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var ray = $RayCast2D
onready var tween = $Tween

export var speed = 6


enum {DOWN, LEFT, RIGHT, UP}
var direction = DOWN
var moving:bool = false
var target_cell = position

var movement = [ Vector2.DOWN,  Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
var idle_animations = ['idle_down', 'idle_left', 'idle_right', 'idle_up']
var walk_animations = ['walk_down', 'walk_left', 'walk_right', 'walk_up']

func animate():
	if(moving):
		anim.play(walk_animations[direction])
	else:
		anim.play(idle_animations[direction])

func handled_input():
	if moving:
		return
	
	var target_dir = null
	if Input.is_action_pressed('ui_right'):
		target_dir = RIGHT
	elif Input.is_action_pressed('ui_left'):
		target_dir = LEFT
	elif Input.is_action_pressed('ui_down'):
		target_dir = DOWN
	elif Input.is_action_pressed('ui_up'):
		target_dir = UP
	
	if target_dir != null:
		direction = target_dir
		move(direction)

func move(dir):
	ray.cast_to = movement[dir] * Settings.TILE_SIZE
	ray.force_raycast_update()
	if not ray.is_colliding():
		target_cell = position + movement[dir] * Settings.TILE_SIZE
		tween.interpolate_property(self, 
			"position",
        	position, 
			target_cell,
        	1.0/speed, 
			Tween.TRANS_SINE, 
			Tween.EASE_IN_OUT)
		moving = true
		tween.start()
		


func _process(delta):
	if position == target_cell:
		moving = false
	handled_input()
	animate()