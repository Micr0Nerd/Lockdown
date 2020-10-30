extends Hater


enum {TO_LEFT, TO_RIGHT, STOP}
#var curr_health setget set_curr_health
#var path_len
#var half_path_len = path_len / 2
var direction_of_travel #setget ,get_direction_of_travel

#func get_direction_of_travel():
#	print(direction_of_travel)
#	pass
#var speed_bullet
var rate_of_fire
var target
var frequence_ray_casting = 0.5
#var target_pos : Vector2 = target.position
var squared_dist_nearby = pow(CPEdited.security_with_player_dist_nearby, 2)
var squared_dist_far = pow(CPEdited.security_with_player_dist_far, 2)

#func set_curr_health(arg):
#	curr_health = arg
#	if curr_health <= 0:
#		queue_free()
	
func _ready():
	randomize()
	curr_health = CPEdited.security_max_health
	direction_of_travel = randi() % 2
	curr_speed = CPEdited.security_speed_patrol
	#speed_bullet = CPEdited.security_speed_bullet
	rate_of_fire = CPEdited.security_rate_of_fire
	damage_to_the_enemy = CPEdited.security_damage_bullet
	target = CPEdited.player
	squared_dist_nearby = pow(CPEdited.security_with_player_dist_nearby, 2)
	squared_dist_far = pow(CPEdited.security_with_player_dist_far, 2)
	
	ray_cast()
	pass

func _process(delta):
	ray_cast()
	if direction_of_travel != STOP:
		if state != ATTACK:
			if direction_of_travel: # TO_RIGHT
				position.x += curr_speed * delta
			else: # TO_LEFT
				position.x -= curr_speed * delta
			pass


func ray_cast():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, target.global_position, [self], collision_mask)
	if result:
		var obj = result.collider
#		if obj is StaticBody2D && state != BASE:
#		if obj.name.begins_with("TileMap") && state != BASE:
		if obj.name == "TileMap" && state != BASE:
			self.state = BASE
			if direction_of_travel == STOP:
				if global_position.x > curr_wall.global_position.x:
					direction_of_travel = TO_RIGHT
				else:
					direction_of_travel = TO_LEFT
		elif obj is Player:
			var squared_dist = global_position.distance_squared_to(obj.global_position)
			if squared_dist <= squared_dist_nearby:
				if direction_of_travel != STOP:
					if state != RUN_AWAY: # || direction_of_travel != STOP:
						self.state = RUN_AWAY
						if global_position.angle_to_point(obj.global_position) < PI / 2: # || position.angle_to(obj.position) > PI + PI / 2 :
							direction_of_travel = TO_RIGHT
						else:
							direction_of_travel = TO_LEFT
			elif squared_dist >= squared_dist_far:
				if state != ATTACK:
					self.state = ATTACK
		elif obj is Drone:
			if state != ATTACK:
				self.state = ATTACK

#	yield(get_tree().create_timer(frequence_ray_casting), "timeout")
#	ray_cast()

#var bullet_1 = preload("res://Bullet/Bullet.tscn").instance()
#var Bullet_sc = PackedScene("res://Bullet/Bullet.tscn")
var is_visible = false
func attack():
	if is_visible && state == ATTACK:
		var bullet = CPEdited.bullet_1.duplicate()
		bullet.target = target.position
		bullet.speed = CPEdited.security_speed_bullet
		bullet.damage = CPEdited.security_damage_bullet
		bullet.parent = Bullet.SECURITY
		add_child(bullet)
		yield(get_tree().create_timer(rate_of_fire), "timeout")
		attack()
	pass
	


func _on_Security_area_entered(area):
	if state == BASE && direction_of_travel != STOP:
		if area.name == "LeftPoint" && direction_of_travel == TO_LEFT:
			direction_of_travel = TO_RIGHT
		if area.name == "RightPoint" && direction_of_travel == TO_RIGHT:
			direction_of_travel = TO_LEFT
	elif area.name == "PlayerBody":
		self.state = DYING
	
	elif area.name.begins_with("PlatformEdge"):
		direction_of_travel = STOP
		self.state = ATTACK
		curr_wall = area
		
	elif area is Bullet:
		if area.parent != Bullet.SECURITY:
			self.curr_health -= area.damage
			area.queue_free()
	pass # Replace with function body.

var curr_wall
func _on_Security_body_entered(body):
	if body.name == "TileMap":
		direction_of_travel = STOP
		self.state = ATTACK
		curr_wall = body
#	if body is Player:
#		self.state = DYING
	pass # Replace with function body.




func _on_VisibilityNotifier2D_screen_entered():
	is_visible = true
	if state == ATTACK:
		attack()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	is_visible = false
	pass # Replace with function body.
