extends KinematicBody2D

var chicken = preload("res://chicken.tscn")

export var max_speed = 100
export var stand_time = 1
export var move_time = 3

var velocity = Vector2()

enum States {
	STAND,
	MOVE,
}
var state = States.STAND

enum Colors {
	RANDOM,
	GREEN,
	ORANGE
}

export(int, "random", "green", "orange") var color = Colors.RANDOM

signal kid_alive
signal kid_gone

var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_color()
	state = States.STAND
	emit_signal("kid_alive")
	
	#var timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "process_ai")
	add_child(timer)
	timer.start()
	
	process_ai()


func set_color():
	var cstr
	
	# todo there has to be a better way to do this
	if color == Colors.RANDOM:
		match randi() % 2:
			0:
				color = Colors.GREEN
			1:
				color = Colors.ORANGE
	match color:
		Colors.GREEN:
			cstr = "green"
		Colors.ORANGE:
			cstr = "orange"
	
	$AnimatedSprite.animation = cstr
	

func transform():
	var chk = chicken.instance()
	chk.position = position
	chk.rotation = rotation
	get_parent().add_child(chk)
	emit_signal("kid_gone")
	queue_free()


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

	match state:
		States.STAND:
			state = States.MOVE
			state_time = standing()
		States.MOVE:
			state = States.STAND
			state_time = moving()
	
	timer.set_wait_time(state_time)
	

func _physics_process(_delta):
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		
	velocity = move_and_slide(velocity)
	
