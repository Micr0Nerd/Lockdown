extends RigidBody2D

class_name Player

const state_base_tex = preload("res://Player/Images/energy_base.png")
const state_overpower_tex = preload("res://Player/Images/energy_overpower.png")

enum {BASE, OVER_POWER}
var state = BASE setget set_state
var is_overpower = false

export var dump = 2
export var _bounce = 0.3
export var speed = Vector2(100,100)
var part_speed = Vector2(speed.x / 4, speed.y / 4)

var rate_of_fire

var drone_number = 4 setget set_drone_number

func set_drone_number(arg):
	drone_number = arg
	if drone_number == 0:
		game_over()

func set_state(arg):
	var old_state = state
	state = arg
	if state == BASE:
		$CollisionShape2D/Sprite.texture = state_base_tex
		is_overpower = false
		$OverPower/CollisionShape2D.set_deferred("disabled", true)
		
	elif state == OVER_POWER:
		$CollisionShape2D/Sprite.texture = state_overpower_tex
		is_overpower = true
		$OverPower/CollisionShape2D.set_deferred("disabled", false)


func _init():
	CPEdited.player = self

func _ready():
	gravity_scale = 1
	#CPEdited.player = self
	bounce = _bounce
	$Timer.wait_time = CPEdited.player_overpower_time
	$TimerAttack.wait_time = CPEdited.player_rate_of_fire
	rate_of_fire = CPEdited.player_rate_of_fire
	pass # Replace with function body.

var is_overpower_forever = false

func game_over():
	is_overpower_forever = true
	self.state = OVER_POWER
	get_parent().game_over()
	pass

enum {NONE, UP, DOWN, LEFT, RIGHT}
var applyed_impulse = Vector2()
func _input(event):
	if event is InputEvent:
		input_base()
	#if event is InputEventKey
		pass
		
		
func input_base():
	if Input.is_action_pressed("ui_up"):
		is_overpower_forever = true
		self.state = OVER_POWER
		linear_damp = -1
		linear_velocity.y = -speed.y
	if Input.is_action_just_released("ui_up"):
		$Timer.start()
		is_overpower_forever = false
		linear_velocity.y = 0
		linear_damp = dump
		yield(get_tree(), "idle_frame")
		apply_impulse(Vector2(0, -speed.y), Vector2(0, -speed.y))

	if Input.is_action_pressed("ui_down"):
		linear_damp = -1
		linear_velocity.y = speed.y
	if Input.is_action_just_released("ui_down"):
		linear_velocity.y = 0
		linear_damp = dump
		yield(get_tree(), "idle_frame")
		apply_impulse(Vector2(0,speed.y), Vector2(0,speed.y))

	if Input.is_action_pressed("ui_left"):
		linear_damp = -1
		linear_velocity.x = -speed.x
	if Input.is_action_just_released("ui_left"):
		linear_velocity.x = 0
		linear_damp = dump
		yield(get_tree(), "idle_frame")
		apply_impulse(Vector2(-speed.x,0), Vector2(-speed.x,0))
	if Input.is_action_pressed("ui_right"):
		linear_damp = -1
		linear_velocity.x = speed.x
	if Input.is_action_just_released("ui_right"):
		linear_velocity.x = 0
		linear_damp = dump
		yield(get_tree(), "idle_frame")
		apply_impulse(Vector2(speed.x,0), Vector2(speed.x,0))
		
	if Input.is_action_just_pressed("ui_aim"):
		# выстрел  ГГ
		Input.set_custom_mouse_cursor(mouse_clicked)
		is_attack = true
		attack()
		pass

	if Input.is_action_just_released("ui_aim"):
		# завершение выстрела  ГГ
		Input.set_custom_mouse_cursor(mouse_unclicked)
		is_attack = false
		pass

const mouse_unclicked = preload("res://Player/Images/target_unclicked.png")
const mouse_clicked = preload("res://Player/Images/target.png")
		
#var bullet_1 = preload("res://Bullet/Bullet.tscn").instance()
var is_attack = false
func attack():
	if is_attack:
		var bullet = CPEdited.bullet_1.duplicate()
		#bullet.target = get_local_mouse_position()
		var target = get_global_mouse_position()
		bullet.speed = CPEdited.player_speed_bullet
		bullet.damage = CPEdited.player_damage_bullet
		bullet.parent = 0
		bullet.distance = CPEdited.player_bullet_distance
		
		target.x += 15 # коррекция - смещение центра с кончика стрелки курсора
		target.y += 15 # в центр прицела
###################################################
		# Нахождение точки для вытрела (перемещения от глобальных координат локального объекта
		# c коррекцией его вращения вокруг своей оси) на расстояние CPEdited.player_bullet_distance
		# от его центра в глобальных координатах с назначением этой точки пуле, которая спавнится
		# в верхнем слое (в корневой сцене) для предотвращения влияния на ее траекторию 
		# вращения локального объекта, от которого она летит
		# var target = get_global_mouse_position()
		var direct = (target - global_position).rotated(-rotation).normalized()
		var aim = direct * CPEdited.player_bullet_distance
		
		bullet.aim = to_global(aim)
		get_parent().add_child(bullet)
		bullet.position = global_position
		#yield(get_tree().create_timer(rate_of_fire), "timeout")
		$TimerAttack.start()
	pass


func remove_dron(_dron : RigidBody2D):
	_dron.self_destroy()
	pass
	
var is_teleport = false
var teleport_pos

func teleport(_teleport_pos : Vector2):
	is_teleport = true
	teleport_pos = _teleport_pos
	self.state = OVER_POWER
	yield(get_tree().create_timer(CPEdited.teleport_time_befor), "timeout")
	self.state = BASE
	set_deferred("sleeping", true)
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_1):
		$DronePositions/Drone_1/PinJoint2D/Drone_1.sleep_on()
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_2):
		$DronePositions/Drone_2/PinJoint2D/Drone_2.sleep_on()
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_3):
		$DronePositions/Drone_3/PinJoint2D/Drone_3.sleep_on()
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_4):
		$DronePositions/Drone_4/PinJoint2D/Drone_4.sleep_on()
	yield(get_tree(),"idle_frame")
	position = _teleport_pos
	yield(get_tree(),"idle_frame")
	set_deferred("sleeping", false)
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_1):
		$DronePositions/Drone_1/PinJoint2D/Drone_1.sleep_off()
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_2):
		$DronePositions/Drone_2/PinJoint2D/Drone_2.sleep_off()
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_3):
		$DronePositions/Drone_3/PinJoint2D/Drone_3.sleep_off()
	if is_instance_valid($DronePositions/Drone_1/PinJoint2D/Drone_4):
		$DronePositions/Drone_4/PinJoint2D/Drone_4.sleep_off()
	#self.state = BASE
	is_teleport = false
	#is_teleport = true
	
#func _integrate_forces(state):
#	if is_teleport:
#		#state.transform = Transform2D(0.0, teleport_pos)
#		self.state = OVER_POWER
#		yield(get_tree().create_timer(CPEdited.teleport_time_befor), "timeout")
#		set_deferred("sleeping", true)
#		var t = state.get_transform()
#
#		t.origin = teleport_pos
#
#		#t.origin.y = new_pos_y
#
#		state.set_transform (t)
#		yield(get_tree(), "idle_frame")
#		sleeping = false
##		set_deferred("sleeping", false)
#		is_teleport = false

	
func _on_PlayerBody_area_entered(area):
	if area.name.begins_with("Bullet"):
		if area.parent != 0 && !is_sleeping():
			area.queue_free()
			self.state = OVER_POWER
			if !is_teleport:
				$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	if !is_overpower_forever:
		self.state = BASE
	pass # Replace with function body.


func _on_OverPower_area_entered(area):
	if area is Hater:
		area.curr_health -= CPEdited.player_damage_overpower
		if is_overpower && area.curr_health > 0:
			yield(get_tree().create_timer(1),"timeout")
			_on_OverPower_area_entered(area)
	pass # Replace with function body.


func _on_OverPower_body_entered(body):
	if is_instance_valid(body) && body.name.begins_with("Drone"):
		body.curr_health -= CPEdited.player_damage_overpower
		if is_overpower && body.curr_health > 0:
			yield(get_tree().create_timer(1),"timeout")
			_on_OverPower_body_entered(body)
	pass # Replace with function body.


func _on_OverPower_area_exited(area):
	pass # Replace with function body.


func _on_OverPower_body_exited(body):
	pass # Replace with function body.


func _on_TimerAttack_timeout():
	attack()
	pass # Replace with function body.
