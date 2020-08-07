extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum States {
	STAND,
	MOVE,
}

var state = States.STAND
var velocity = Vector2()
export var max_speed =  10
export var stand_time = 3
export var move_time = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	match randi() % 2:
		0:
			$AnimatedSprite.animation = "yellow"
		1:
			$AnimatedSprite.animation = "white"
	state = States.STAND
	process_ai()

func standing():
	velocity = Vector2()
	return rand_range(0, stand_time)

func moving():
	velocity = Vector2(
		rand_range(0, max_speed) - rand_range(0, max_speed), 
		rand_range(0, max_speed) - rand_range(0, max_speed)
	)
	return rand_range(0, move_time)
	

func process_ai():
	var state_time = 1
	while true:
		match state:
			States.STAND:
				state = States.MOVE
				state_time = standing()
			States.MOVE:
				state = States.STAND
				state_time = moving()
		
		yield(get_tree().create_timer(state_time), "timeout")
	

func _physics_process(delta):
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		
	velocity = move_and_slide(velocity)
