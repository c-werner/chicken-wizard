extends Node2D

var dead = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spell = preload("res://Spell.tscn")
var can_fire = true
export var rate_of_fire = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func die():
	dead = true

func cast_spell():
	can_fire = false
	var spell_instance = spell.instance()
	spell_instance.position = get_parent().position
	spell_instance.rotation = rotation
	get_parent().get_parent().add_child(spell_instance)
	yield(get_tree().create_timer(rate_of_fire), "timeout")
	can_fire = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead:
		var mouse_position = get_viewport().get_mouse_position() # + camera.global_position
		look_at(mouse_position)
	
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_fire:
			cast_spell()
