extends KinematicBody2D

export var speed = 100
var screen_size 
var dead = false
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	dead = false
	velocity = Vector2()

func process_input():
	var left = Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A)
	var right = Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D)
	var up = Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W)
	var down = Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S)
	
	velocity.x = -int(left) + int(right)
	velocity.y = -int(up) + int(down)
	
	
func live(_delta):
	if Input.is_key_pressed(KEY_K):
		die()
		return
	
	process_input()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	velocity = move_and_slide(velocity)
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0

func die():
	dead = true
	$AnimatedSprite.play("dead")
	rotation_degrees = 270 # lay down
	$Blood.emitting = true
	$Wand.die()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not dead:
		live(delta)
	
	
	
