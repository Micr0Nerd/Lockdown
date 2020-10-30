extends Area2D

class_name Bullet

enum {PLAYER, SECURITY}
var parent
var speed
var target : Vector2
var direct : Vector2
var damage
var distance = 0
var aim


func target_correction():
	target.x += 15
	target.y += 15
	#global_rotation -= global_rotation
	pass
	

func _ready():
	if parent == SECURITY:
		direct = global_position.direction_to(target)

	pass

func _process(delta):
	if distance:
		global_position = global_position.move_toward(aim, speed * delta)
		if global_position.is_equal_approx(aim):
			queue_free()

	else:
		global_position.x += direct.x * speed * delta
		global_position.y += direct.y * speed * delta
	pass
	
	#global_position = global_position.move_toward(target, speed * delta)



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_Bullet_body_entered(body):
	if body is Drone:
		body.curr_health -= damage
		queue_free()
	
	if body.name == "TileMap":
		queue_free()
	pass # Replace with function body.
	



#func _on_Bullet_area_entered(area):
#	if area.name.begins_with("Teleport"):
#		if parent is Player:
#
#	pass # Replace with function body.
