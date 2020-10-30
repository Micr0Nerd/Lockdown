extends Area2D

class_name Hater

enum {BASE, ATTACK, RUN_AWAY, DYING}
#enum {TO_LEFT, TO_RIGHT, STOP}

var state = BASE setget set_state
var damage_to_the_enemy
var curr_health setget set_curr_health
var curr_speed
#var direction_of_travel

func set_state(arg):
	state = arg
	match arg:
		BASE:
			curr_speed = CPEdited.security_speed_patrol
		RUN_AWAY:
			curr_speed = CPEdited.security_speed_run
		ATTACK:
			attack()
		DYING:
			dying()

func set_curr_health(arg):
	curr_health = arg
	if curr_health <= 0:
		queue_free()
		
		
func _ready():
	pass

func attack():
	pass
	
func dying():
	queue_free()
	pass
