extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 200
var life_time = 3
var Poof = preload("res://Poof.tscn")

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(Vector2(speed, 0).rotated(rotation))
	killself()


func killself():
	yield(get_tree().create_timer(life_time), "timeout")
	collide()
	#queue_free()
	
func collide():
	$Sprite/Trail.emitting = false
	$Sprite.visible = false
	var poof = Poof.instance()
	poof.position = position
	poof.emitting = true
	get_parent().add_child(poof)
	emit_signal("hit")
	queue_free()


func _on_Spell_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("player"):
		return
	if body.is_in_group("mobs"):
		body.transform()
	collide()


func _on_Spell_body_entered(body):
	if body.is_in_group("player"):
		return
	if body.is_in_group("mobs"):
		body.transform()
	collide()
