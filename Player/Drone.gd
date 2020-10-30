extends RigidBody2D

class_name Drone

#var max_health
#var middle_health
enum {BROKEN, MIDDLE, MAX}
var curr_health = CPEdited.drone_max_health setget set_curr_health
var curr_health_status = MAX

const max_tex = preload("res://Player/Images/drone_top.png")
const middle_tex = preload("res://Player/Images/drone_middle.png")
const broken_tex = preload("res://Player/Images/drone_down.png")

var is_repaired = false
var repair_slot_path
var DroneRepairStation

func set_curr_health(arg):
	curr_health = arg
	if curr_health >= CPEdited.drone_max_health:
		return
		
	if arg > 0:
		#curr_health = arg
		if curr_health > CPEdited.drone_middle_health && curr_health_status != MAX:
			curr_health_status = MAX
			$CollisionShape2D/Sprite.texture = max_tex
			
		if curr_health > 0 && curr_health <= CPEdited.drone_middle_health && curr_health_status != MIDDLE:
			curr_health_status = MIDDLE
			$CollisionShape2D/Sprite.texture = middle_tex
	if arg <= 0:
		curr_health = 0
		if curr_health_status != BROKEN:
			curr_health_status = BROKEN
			#$CollisionShape2D/Sprite.texture = broken_tex
			self_destroy()
		

var player = CPEdited.player
var squared_dist_for_destroy

func sleep_on():
	mode = RigidBody2D.MODE_STATIC

func sleep_off():
	mode = RigidBody2D.MODE_RIGID
	
var squared_dist_for_detach_from_repaere

func _ready():
#	max_health = CPEdited.drone_max_health
#	middle_health = CPEdited.drone_middle_health
	self.curr_health = CPEdited.drone_max_health
	$CollisionShape2D/Sprite.texture = max_tex
	player = CPEdited.player
	squared_dist_for_destroy = pow(CPEdited.drone_distance_for_destroy, 2)
	var t = position.distance_to(CPEdited.player.position)
	#squared_dist_for_player = pow(global_position.distance_squared_to(CPEdited.player.global_position), 2)
	squared_dist_for_detach_from_repaere = t * t + CPEdited.drs_squared_drone_shutdown_warning_threshold #+ squared_dist_for_player
	ray_cast()
	pass



func ray_cast():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask)
	if result:
		var obj = result.collider
		if obj.name == "TileMap":
			self_destroy()
		elif obj is Player:
			if is_repaired: # если подключен к ремонтнику, то отключаюсь
				var t = position.distance_squared_to(obj.position)
				if position.distance_squared_to(obj.position) >= squared_dist_for_detach_from_repaere:
					DroneRepairStation.detach_drone(self, repair_slot_path)
			if global_position.distance_squared_to(obj.global_position) >= squared_dist_for_destroy:
				self_destroy()
	yield(get_tree().create_timer(CPEdited.drone_rate_for_ray_casting), "timeout")
	if is_instance_valid(self) && name.begins_with("Drone"):
		ray_cast()


func self_destroy():
	player.drone_number -= 1
	get_parent().queue_free()
	pass

