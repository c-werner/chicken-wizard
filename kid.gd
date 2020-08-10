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
var ai_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_color()
	state = States.STAND
	emit_signal("kid_alive")
	
	process_ai(0)


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
	

func process_ai(delta):
	ai_timer -= delta
	if ai_timer > 0:
		return

	match state:
		States.STAND:
			state = States.MOVE
			ai_timer = standing()
		States.MOVE:
			state = States.STAND
			ai_timer = moving()

func _process(delta):
	process_ai(delta)

func _physics_process(_delta):
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
		
	velocity = move_and_slide(velocity)
	
