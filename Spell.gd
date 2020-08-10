extends RigidBody2D

export var speed = 200
var life_time = 3
var Poof = preload("res://Poof.tscn")

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(Vector2(speed, 0).rotated(rotation))
	
	var timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "collide")
	add_child(timer)
	timer.start()
	
func collide():
	$Sprite/Trail.emitting = false
	$Sprite.visible = false
	var poof = Poof.instance()
	poof.position = position
	poof.emitting = true
	get_parent().add_child(poof)
	emit_signal("hit")
	queue_free()


func _on_Spell_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body.is_in_group("player"):
		return
	if body.is_in_group("mobs"):
		body.call_deferred("transform")
	collide()


func _on_Spell_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.is_in_group("mobs"):
		body.transform()
	collide()
