class_name Player
extends KinematicBody2D

enum {
	MOVE
}

export(int) var  acceleration = 500
export(int) var max_speed = 80
export(int) var friction = 500


var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var inpunt_vector = Vector2.ZERO

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	inpunt_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inpunt_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inpunt_vector = inpunt_vector.normalized()

	if inpunt_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", inpunt_vector)
		animationTree.set("parameters/Run/blend_position", inpunt_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inpunt_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move()

func move():
	velocity = move_and_slide(velocity)

