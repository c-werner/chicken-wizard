extends RigidBody2D

export var speed = 200
var life_time = 2
var Poof = preload("res://Poof.tscn")

signal hit
var ttl = life_time

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(Vector2(speed, 0).rotated(rotation))
	ttl = life_time
	
func collide():
	$Sprite/Trail.emitting = false
	$Sprite.visible = false
	var poof = Poof.instance()
	poof.position = position
	poof.emitting = true
	get_parent().add_child(poof)
	emit_signal("hit")
	queue_free()

func _process(delta):
	ttl -= delta
	if ttl <= 0:
		collide()


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
