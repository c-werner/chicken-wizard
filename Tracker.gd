extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var total_kids = 0

signal win

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	total_kids = len(get_tree().get_nodes_in_group("mobs"))
	
	if total_kids == 0:
		emit_signal("win")

