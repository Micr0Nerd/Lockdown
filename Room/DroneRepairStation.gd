extends RigidBody2D


func _ready():
	pass


func _on_DroneRepairStation_body_entered(body):
#	if body is Drone:
#		if body.curr_health < CPEdited.drone_max_health:
#			$DampedSpringJoint2D.node_b = body
#			pass
	pass # Replace with function body.

var drone_list = []
func _on_Area2D_body_entered(body):
	if body is Drone && !drone_list.has(body):
		if body.curr_health < CPEdited.drone_max_health:
			if $Slot_1.node_b == "":
				$Slot_1.node_a = self.get_path()
				$Slot_1.node_b = body.get_path()
				body.repair_slot_path = "Slot_1"
				drone_list.append(body)
				repair(body, "Slot_1")
			elif $Slot_2.node_b == "":
				$Slot_2.node_a = self.get_path()
				$Slot_2.node_b = body.get_path()
				body.repair_slot_path = "Slot_2"
				drone_list.append(body)
				repair(body, "Slot_2")
			elif $Slot3.node_b == "":
				$Slot_3.node_a = self.get_path()
				$Slot_3.node_b = body.get_path()
				body.repair_slot_path = "Slot_3"
				drone_list.append(body)
				repair(body, "Slot_3")
			elif $Slot_4.node_b == "":
				$Slot_4.node_a = self.get_path()
				$Slot_4.node_b = body.get_path()
				body.repair_slot_path = "Slot_4"
				drone_list.append(body)
				repair(body, "Slot_4")
			body.is_repaired = true
			body.DroneRepairStation = self
			#$Area2D/CollisionShape2D.set_deferred("disabled", true)
			pass
	pass # Replace with function body.

func repair(_drone : Drone, _path_slot : String):
	if _drone && _drone.curr_health < CPEdited.drone_max_health:
		_drone.curr_health += CPEdited.drs_drone_repair_speed
		yield(get_tree().create_timer(1), "timeout")
		repair(_drone, _path_slot)
	elif _drone:
		_drone.curr_health = CPEdited.drone_max_health
		detach_drone(_drone, _path_slot)
	pass

func detach_drone(_drone : Drone, _path_slot):
	get_node(_path_slot).node_a = ""
	get_node(_path_slot).node_b = ""
	if drone_list.has(_drone):
		drone_list.erase(_drone)
	_drone.is_repaired = false
	_drone.repair_slot_path = null
	
